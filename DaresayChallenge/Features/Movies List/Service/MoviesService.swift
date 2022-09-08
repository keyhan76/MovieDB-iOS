//
//  MoviesService.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-28.
//

import Foundation

// Using Decorator pattern for Service and ViewModel

protocol MoviesServiceProtocol {
    func getMovies(httpRequest: HTTPRequest) async -> (ServerModels.Movies.Response?, APIError?)
    func getConfigs(httpRequest: HTTPRequest) async -> (ServerModels.Configuration.Response?, APIError?)
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
    
    public static let shared: MoviesServiceProtocol = MoviesService(serverManager: MovieServer.shared)
    
    // MARK: - Init
    init(serverManager: ServerProtocol) {
        self.serverManager = serverManager
    }
}

// MARK: - MoviesService Protocol
extension MoviesService: MoviesServiceProtocol {
    func getMovies(httpRequest: HTTPRequest) async -> (ServerModels.Movies.Response?, APIError?) {
            do {
                let movies: ServerData<ServerModels.Movies.Response> = try await serverManager.perform(request: httpRequest)
                return (movies.model, nil)
            } catch {
                return (nil, error as? APIError)
            }
    }
    
    func getConfigs(httpRequest: HTTPRequest) async -> (ServerModels.Configuration.Response?, APIError?) {
        do {
            let configs: ServerData<ServerModels.Configuration.Response> = try await serverManager.perform(request: httpRequest)
            return (configs.model, nil)
        } catch {
            return (nil, error as? APIError)
        }
    }
}
