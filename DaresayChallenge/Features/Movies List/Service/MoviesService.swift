//
//  MoviesService.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-28.
//

import Foundation

// Using Decorator pattern for Service and ViewModel

protocol MoviesServiceProtocol {
    var coreDataAPI: CoreDataAPI { get }
    
    func getMovies(httpRequest: HTTPRequest, managedContext: ManagedObjectContext) async throws -> ServerModels.Movies.Response
    func getConfigs(httpRequest: HTTPRequest) async throws -> ServerModels.Configuration.Response
}

// MARK: - Server Request
extension ServerRequest {
    enum Movies {
        static func getMovies(page: UInt) -> HTTPRequest {
            var url = RequestURL()
            url.appendPathComponents([.version, .movie, .popular])
            let headers: [String: String] = baseRequestHeaders
            let params: [String: Any] = ["page": "\(page)"]
            
            return HTTPRequest(method: .GET, url: url, auth: .otp, parameters: params, bodyMessage: nil, headers: headers, timeOut: .normal)
        }
    }
    
    enum Configuration {
        static func getConfigs() -> HTTPRequest {
            var url = RequestURL()
            url.appendPathComponents([.version, .config])
            let headers: [String: String] = baseRequestHeaders
            
            return HTTPRequest(method: .GET, url: url, auth: .otp, parameters: nil, bodyMessage: nil, headers: headers, timeOut: .normal)
        }
    }
}

// MARK: - Movies Service
final class MoviesService {
    private let serverManager: ServerProtocol
    let coreDataAPI: CoreDataAPI
    
    // MARK: - Init
    init(serverManager: ServerProtocol, coreDataAPI: CoreDataAPI) {
        self.serverManager = serverManager
        self.coreDataAPI = coreDataAPI
    }
}

// MARK: - MoviesService Protocol
extension MoviesService: MoviesServiceProtocol {
    func getMovies(httpRequest: HTTPRequest, managedContext: ManagedObjectContext) async throws -> ServerModels.Movies.Response {
        let result: ServerData<ServerModels.Movies.Response> = try await serverManager.perform(request: httpRequest, managedObjectContext: managedContext)
        
        return result.model
    }
    
    func getConfigs(httpRequest: HTTPRequest) async throws -> ServerModels.Configuration.Response {
        let configs: ServerData<ServerModels.Configuration.Response> = try await serverManager.perform(request: httpRequest)
        return configs.model
    }
}
