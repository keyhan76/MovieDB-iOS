//
//  MovieDetailService.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-10-04.
//

import Foundation
import CoreData

protocol MovieDetailServiceProtocol {
    var coreDataAPI: CoreDataAPI { get }
    
    func fetchFavoriteMovie(with movieID: Int64) throws -> Movie?
    func saveMovieInDB(selectedMovie: Movie) -> Movie 
    func updateSaved(movie: Movie)
}

final class MovieDetailService {
    
    // MARK: - Variables
    let coreDataAPI: CoreDataAPI
    
    // MARK: - Init
    init(coreDataAPI: CoreDataAPI) {
        self.coreDataAPI = coreDataAPI
    }
}

// MARK: - MovieDetailService Protocol
extension MovieDetailService: MovieDetailServiceProtocol {
    func saveMovieInDB(selectedMovie: Movie) -> Movie {
        let newMovieObject = coreDataAPI.createManagedObject(entity: Movie.self) as! Movie

        newMovieObject.movieID = selectedMovie.movieID
        newMovieObject.title = selectedMovie.title
        newMovieObject.overview = selectedMovie.overview
        newMovieObject.isFavorite = selectedMovie.isFavorite
        newMovieObject.posterPath = selectedMovie.posterPath
        newMovieObject.voteAverage = selectedMovie.voteAverage
        
        coreDataAPI.save()
        
        return newMovieObject
    }
    
    func fetchFavoriteMovie(with movieID: Int64) throws -> Movie? {
        let predicate = NSPredicate(format: "movieID == %ld", movieID)
        
        let movie = try coreDataAPI.fetchObject(predicate: predicate, entity: Movie.self).first
        return movie
    }
    
    func updateSaved(movie: Movie) {
        
        let propertiesToUpdate = ["isFavorite": !movie.isFavorite]
        let predicate = NSPredicate(format: "movieID == %ld", movie.movieID)
        
        do {
            try coreDataAPI.batchUpdate(entity: Movie.self, propertiesToUpdate: propertiesToUpdate, predicate: predicate)
        } catch {
            print(error)
        }
    }
}
