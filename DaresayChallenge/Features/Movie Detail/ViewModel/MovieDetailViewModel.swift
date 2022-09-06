//
//  MovieDetailViewModel.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-06.
//

import Foundation
import CoreData

final class MovieDetailViewModel {
    
    // MARK: - Variables
    private let coreDataAPI: CoreDataAPI
    public let selectedMovie: MoviesModel
    
    // MARK: - Init
    init(coreDataAPI: CoreDataAPI, selectedMovie: MoviesModel) {
        self.coreDataAPI = coreDataAPI
        self.selectedMovie = selectedMovie
    }
    
    // MARK: - Public methods
    func addToFavorites(isFavorite: Bool) {
        let movie = coreDataAPI.createManagedObject(entity: Movie.self)  as! Movie
        
        movie.id = Int64(selectedMovie.movieID ?? 0)
        movie.imageURL = selectedMovie.backgroundImageURL
        movie.title = selectedMovie.originalTitle
        movie.movieDescription = selectedMovie.overview
        movie.isFavorite = isFavorite
        
        do {
            try coreDataAPI.save()
        } catch let error {
            print(error)
        }
    }
    
    func isAvailableInFavorites() -> Bool {
        do {
            let objects = try coreDataAPI.fetchObject(movieID: selectedMovie.movieID ?? 0, entity: Movie.self)
            if let movie = objects.first {
                return movie.isFavorite
            }
        } catch let error {
            print(error)
        }
        
        return false
    }
}
