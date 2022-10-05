//
//  MovieMock.swift
//  DaresayChallengeTests
//
//  Created by Keihan Kamangar on 2022-10-05.
//

import Foundation
@testable import DaresayChallenge

struct MockData {
    
    static let coreDataStore = CoreDataStore(.inMemory)
    static var coreDataAPI: CoreDataAPI! {
        CoreDataAPI(managedContext: coreDataStore.mainContext, importContext: coreDataStore.importContext, coreDataStore: coreDataStore)
    }
    
    static let movieSample = Movie(movieID: 100,
                              overview: "Movie overview",
                              posterPath: "https://www.apple.com",
                              title: "Movie title",
                              voteAverage: 3.5,
                              isFavorite: false,
                              context: MockData.coreDataAPI.importContext)
}
