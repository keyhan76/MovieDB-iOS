//
//  MovieDetailViewModel.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-06.
//

import Foundation

final class MovieDetailViewModel {
    private let coreDataAPI: CoreDataAPI
    public let selectedMovie: MoviesModel
    
    init(coreDataAPI: CoreDataAPI, selectedMovie: MoviesModel) {
        self.coreDataAPI = coreDataAPI
        self.selectedMovie = selectedMovie
    }
}
