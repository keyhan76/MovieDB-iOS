//
//  MoviesViewModelTest.swift
//  DaresayChallengeTests
//
//  Created by Keihan Kamangar on 2022-06-30.
//

import XCTest
@testable import DaresayChallenge

class MoviesViewModelTest: XCTestCase {

    var sut: MoviesViewModel?
    
    override func setUp() async throws {
        try await  super.setUp()
    }

    override func tearDown() async throws {
        sut = nil
        try await  super.tearDown()
    }
    
    func testGetMovies() async {
        let moviesService = MoviesService(serverManager: MovieServer.shared, coreDataAPI: MockData.coreDataAPI)
        sut = MoviesViewModel(moviesService: moviesService)
        
        let movies = await sut?.getPopularMovies()
        
        XCTAssertNotNil(movies)
    }

    func testPopulate() async {
        let moviesService = MoviesService(serverManager: MovieServer.shared, coreDataAPI: MockData.coreDataAPI)
        sut = MoviesViewModel(moviesService: moviesService)
        
        
        let movies = await sut?.populate()
        XCTAssertNotNil(movies)
    }
}
