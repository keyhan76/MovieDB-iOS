//
//  FavoriteMoviesViewModel.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-29.
//

import Foundation

final class FavoriteMoviesViewModel: MoviesViewModel {
    
    // MARK: - Variables
    
    override var itemsCount: Int {
        favoriteMovies.count
    }
    
    public var favoriteMovies: [MoviesModel]
    
    // MARK: - Init
    init(favoriteMovies: [MoviesModel] = UserDefaultsData.favoriteList) {
        self.favoriteMovies = favoriteMovies
        super.init(moviesService: MoviesService.shared)
    }
    
    // MARK: - Helpers
    override func item(at index: Int) -> MoviesModel {
        favoriteMovies[index]
    }
}
