//
//  MoviesServiceTest.swift
//  DaresayChallengeTests
//
//  Created by Keihan Kamangar on 2022-06-29.
//

import XCTest
@testable import DaresayChallenge

class MoviesServiceTest: XCTestCase {

    var sut: MoviesService?
    var moviesJSON: Data?
    var configsJSON: Data?
    
    override func setUp() async throws {
        try await super.setUp()
        
        let bundle = Bundle(for: type(of: self))
        do {
            let moviesPath = try XCTUnwrap(bundle.url(forResource:"movies", withExtension: "json"))
            let moviesData = try Data(contentsOf: moviesPath, options: .alwaysMapped)
            
            let configsPath = try XCTUnwrap(bundle.url(forResource:"configs", withExtension: "json"))
            let configsData = try Data(contentsOf: configsPath, options: .alwaysMapped)
            
            
            self.moviesJSON = moviesData
            self.configsJSON = configsData
        } catch {
            XCTFail("Failed to read JSON files.")
        }
    }
    
    override func tearDown() async throws {
        sut = nil
        moviesJSON = nil
        configsJSON = nil
        try await super.tearDown()
    }
    
    func testGetMovies() async throws {
        var url = RequestURL()
        url.appendPathComponents([.version, .movie, .popular])
        
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: url.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, self.moviesJSON!)
        }
        
        let session = createURLSession()
        
        let networkMock = NetworkingMock(session: session, validResponseCodes: [200])
        
        sut = MoviesService(serverManager: networkMock, coreDataAPI: MockData.coreDataAPI)

        let httpRequest = getMovies(url: url, page: 1)
        
        let result = try await sut?.getMovies(httpRequest: httpRequest, managedContext: MockData.coreDataAPI.importContext)
        
        let movies = try XCTUnwrap(result?.results)
        
        XCTAssert(!movies.isEmpty)
    }
    
    func testGetConfigs() async throws {
        var url = RequestURL()
        url.appendPathComponents([.version, .config])
        
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: url.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, self.configsJSON!)
        }
        
        let session = createURLSession()
        
        let networkMock = NetworkingMock(session: session, validResponseCodes: [200])
        
        sut = MoviesService(serverManager: networkMock, coreDataAPI: MockData.coreDataAPI)
        
        let httpRequest = getConfigs(url: url)
        
        let result = try await sut?.getConfigs(httpRequest: httpRequest)
        
        let configs = try XCTUnwrap(result)
        
        XCTAssertTrue(!configs.changeKeys!.isEmpty)
        XCTAssertTrue(configs.images != nil)
    }
}

// MARK: - Helpers
extension MoviesServiceTest {
    func createURLSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        let session = URLSession(configuration: config)
        
        return session
    }
    
    func getMovies(url: RequestURL, page: UInt) -> HTTPRequest {
        let headers: [String: String] = baseRequestHeaders
        let params: [String: Any] = ["page": "\(page)"]
        
        return HTTPRequest(method: .GET, url: url, auth: .otp, parameters: params, bodyMessage: nil, headers: headers, timeOut: .normal)
    }
    
    func getConfigs(url: RequestURL) -> HTTPRequest {
        let headers: [String: String] = baseRequestHeaders
        
        return HTTPRequest(method: .GET, url: url, auth: .otp, parameters: nil, bodyMessage: nil, headers: headers, timeOut: .normal)
    }
}
