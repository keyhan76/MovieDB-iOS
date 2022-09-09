//
//  NetworkingMock.swift
//  DaresayChallengeTests
//
//  Created by Keihan Kamangar on 2022-06-29.
//

import Foundation
@testable import DaresayChallenge

class NetworkingMock: ServerProtocol {
    var session: URLSession!
    
    var dispatchQueue: DispatchQueue!
    
    var validResponseCodes: [Int]!
    
    public init(session: URLSession, validResponseCodes: [Int]) {
        self.session = session
        self.validResponseCodes = validResponseCodes
    }
    
    func perform<T: Codable>(request: HTTPRequest) async throws -> ServerData<T> {
        guard let url = request.requestURL.url else {
            throw APIError.invalidURL
        }
        
        var (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard self.validResponseCodes.contains(httpResponse.statusCode) else {
            throw APIError.noResponseData
        }
             
        do {
            if data.isEmpty || T.self == ServerModels.EmptyServerModel.self {
                data = "{}".data(using: .utf8) ?? Data()
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let responseObject = try decoder.decode(T.self, from: data)
            
            return ServerData(httpStatus: 200, model: responseObject, httpHeaders: [:])
            
        } catch {
            throw APIError.parserFailed(error)
        }
    }
}
