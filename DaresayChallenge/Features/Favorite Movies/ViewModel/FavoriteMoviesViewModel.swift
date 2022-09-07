//
//  FavoriteMoviesViewModel.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-29.
//

import Foundation
import CoreData

final class FavoriteMoviesViewModel: MoviesViewModel {
    
    // MARK: - Variables
    
    public lazy var fetchedResultsController: NSFetchedResultsController<Movie> = {
        var controller: NSFetchedResultsController<Movie>!
        
        do {
            controller = try coreDataAPI.fetch(entity: Movie.self)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return controller
    }()
    
    private let coreDataAPI: CoreDataAPI
    
    override var itemsCount: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    // MARK: - Init
    init(coreDataAPI: CoreDataAPI) {
        self.coreDataAPI = coreDataAPI
        super.init(moviesService: MoviesService.shared)
    }
    
    // MARK: - Helpers
    override func item(at index: Int) -> MoviesModel {
        let indexPath = IndexPath(row: index, section: 0)
        let movie = fetchedResultsController.object(at: indexPath)
        
        let movieModel = MoviesModel(title: movie.title, posterURL: movie.imageURL, description: movie.movieDescription)
        
        return movieModel
    }
}
