//
//  SeededURLSession.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-10-05.
//

import Foundation

/// Use this class to mock network calls when UITesting
final class SeededURLProtocol {
    
    private var moviesData: Data?
    
    init() {
        var url = RequestURL()
        url.appendPathComponents([.version, .movie, .popular])
        
        decodeJSONFile()
        
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: url.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, self.moviesData!)
        }
    }
    
    func createURLSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        let session = URLSession(configuration: config)
        
        return session
    }
    
    private func decodeJSONFile() {
        let bundle = Bundle(for: type(of: self))
        guard let moviesPath = bundle.url(forResource:"movies", withExtension: "json") else {
            return
        }
        guard let moviesData = try? Data(contentsOf: moviesPath, options: .alwaysMapped) else {
            fatalError("Couldn't decode Movies.json")
        }
        
        self.moviesData = moviesData
    }
}
