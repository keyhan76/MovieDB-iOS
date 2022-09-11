//
//  MovieDetailViewModel.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-06.
//

import SwiftUI
import CoreData

final class MovieDetailViewModel: ObservableObject {
    
    // MARK: - Variables
    private let coreDataAPI: CoreDataAPI
    public let selectedMovie: MoviesModel
    
    public weak var delegate: ReloadFavoritesDelegate?
    
    private var savedMovie: Movie?
    
    var movieTitle: String {
        selectedMovie.title ?? ""
    }
    
    var movieDescription: String {
        selectedMovie.overview ?? ""
    }
    
    var movieImageURL: URL? {
        selectedMovie.backgroundImageURL
    }
    
    var movieRating: String {
        if let rating = selectedMovie.voteAverage {
            return "Rating: \(String(describing: rating * 10))%"
        }
        return ""
    }
    
    // MARK: - Init
    init(coreDataAPI: CoreDataAPI, selectedMovie: MoviesModel) {
        self.coreDataAPI = coreDataAPI
        self.selectedMovie = selectedMovie
    }
    
    // MARK: - Public methods
    func addToFavorites(isFavorite: Bool) {
        
        selectedMovie.isFavorite = isFavorite
        
        delegate?.refresh(item: selectedMovie)
        
        // If saved movie exists, remove it from database
        if let savedMovie = savedMovie {
            
            do {
                try coreDataAPI.delete(entity: savedMovie)
            } catch let error {
                print(error)
            }
            
            return
        }
        
        let movie = coreDataAPI.createManagedObject(entity: Movie.self)  as! Movie
        
        movie.id = Int64(selectedMovie.movieID ?? 0)
        movie.imageURL = selectedMovie.posterURL
        movie.title = selectedMovie.title
        movie.movieDescription = selectedMovie.overview
        movie.isFavorite = isFavorite
        
        savedMovie = movie
        
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
                savedMovie = movie
                return movie.isFavorite
            }
        } catch let error {
            print(error)
        }
        
        return false
    }
}
