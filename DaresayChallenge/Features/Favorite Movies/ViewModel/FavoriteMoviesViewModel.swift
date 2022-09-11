//
//  FavoriteMoviesViewModel.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-29.
//

import Foundation
import CoreData

final class FavoriteMoviesViewModel {
    
    // MARK: - Variables
    
    var isFinished: Bool = true
    
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
    
    var favoriteMovies: [Movie] {
        fetchedResultsController.fetchedObjects ?? []
    }

    // MARK: - Init
    init(coreDataAPI: CoreDataAPI) {
        self.coreDataAPI = coreDataAPI
    }
}

extension FavoriteMoviesViewModel: ListViewModelable {
    func prefetchData() async -> [Movie] { [] }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool { false }
}
