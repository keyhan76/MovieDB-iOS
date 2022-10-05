//
//  MovieDetailViewModel.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-06.
//

import SwiftUI

final class MovieDetailViewModel: ObservableObject {
    
    // MARK: - Variables
    private let movieDetailService: MovieDetailService
    public let selectedMovie: Movie
    private var savedMovie: Movie?
    
    @Published var isFavoriteMovie: Bool = false
    
    var movieTitle: String {
        selectedMovie.title ?? "No title available"
    }
    
    var movieDescription: String {
        selectedMovie.overview ?? "No description available"
    }
    
    var movieImageURL: URL? {
        selectedMovie.backgroundImageURL
    }
    
    var movieRating: String {
        let rating = selectedMovie.voteAverage
        return "Rating: \(String(describing: rating * 10))%"
    }
    
    var isFavorite: Bool {
        get {
            guard let movie = try? movieDetailService.fetchFavoriteMovie(with: selectedMovie.movieID) else {
                return false
            }
            
            savedMovie = movie
            return movie.isFavorite
        }
        set {
            isFavoriteMovie = newValue
            selectedMovie.isFavorite = newValue
            
            if let savedMovie = savedMovie {
                movieDetailService.updateSaved(movie: savedMovie)
            } else {
                savedMovie = movieDetailService.saveMovieInDB(selectedMovie: selectedMovie)
            }
        }
    }
    
    // MARK: - Init
    init(movieDetailService: MovieDetailService, selectedMovie: Movie) {
        self.movieDetailService = movieDetailService
        self.selectedMovie = selectedMovie
        isFavoriteMovie = isFavorite
    }
}
