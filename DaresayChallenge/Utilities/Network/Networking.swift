//
//  Networking.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-27.
//

import Foundation

protocol ServerProtocol {
    var session: URLSession! { get }
    
    var dispatchQueue: DispatchQueue! { get }
    
    var validResponseCodes: [Int]! { get }
    
    func perform<T: Codable>(request: HTTPRequest, managedObjectContext: ManagedObjectContext?) async throws -> ServerData<T>
}

extension ServerProtocol {
    func perform<T: Codable>(request: HTTPRequest) async throws -> ServerData<T> {
        try await perform(request: request, managedObjectContext: nil)
    }
}

final class MovieServer: NSObject, ServerProtocol {
    
    let session: URLSession!
    
    let dispatchQueue: DispatchQueue!
    
    let validResponseCodes: [Int]!
    
    static let shared = MovieServer()
    
    private override init() {
        self.validResponseCodes = [200, 201]
        self.dispatchQueue = .main
        self.session = Config.urlSession
        super.init()
    }
    
    public init(session: URLSession, dispatchQueue: DispatchQueue, validResponseCodes: [Int]) {
        self.session = session
        self.dispatchQueue = dispatchQueue
        self.validResponseCodes = validResponseCodes
    }
    
    func perform<T: Codable>(request: HTTPRequest, managedObjectContext: ManagedObjectContext?) async throws -> ServerData<T> {
        
        // Check to see if we have a valid request
        guard let urlRequest = request.request else {
            throw APIError.invalidRequest
        }
        
        var (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard self.validResponseCodes.contains(httpResponse.statusCode) else {
            let errorModel = self.generateServerError(from: response, responseData: data, status: httpResponse.statusCode)
            throw APIError.invalidResponseCode(errorModel)
        }
        
        let httpHeader = httpResponse.allHeaderFields
        
        do {
            if data.isEmpty || T.self == ServerModels.EmptyServerModel.self {
                data = "{}".data(using: .utf8) ?? Data()
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let managedObjectContext = managedObjectContext {
                decoder.userInfo[.managedObjectContext] = managedObjectContext
            }
            let responseObject = try decoder.decode(T.self, from: data)
            
            return ServerData(httpStatus: httpResponse.statusCode, model: responseObject, httpHeaders: httpHeader)
            
        } catch {
            throw APIError.parserFailed(error)
        }
    }
    
    private func generateServerError(from urlResponse: URLResponse?, responseData: Data?, status: Int) -> ServerErrorModel {
        
        let url = (urlResponse as? HTTPURLResponse)?.url?.absoluteString
        
        func fallbackErrorModel() -> ServerErrorModel {
            
            return ServerErrorModel(statusCode: status, url: url, messages: nil)
        }
        
        guard let responseData = responseData else {
            return fallbackErrorModel()
        }
        
        do {
            let errorMessages = try JSONDecoder().decode([ServerErrorModel.ServerErrorMessage].self, from: responseData)
            
            let errorModel = ServerErrorModel(statusCode: status, url: url, messages: errorMessages)
            return errorModel
        } catch {
            print("❌ Could not parse server error message!\n\(error) ❌")
            let errorString = String(data: responseData, encoding: .utf8)
            print("❌ ++++++++ [\(url ?? "")] ERROR: \(errorString ?? "") ❌")
            return fallbackErrorModel()
        }
    }
}
