//
//  FavoriteMoviesService.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-10-05.
//

import Foundation
import CoreData

protocol FavoriteMoviesServiceProtocol {
    var coreDataAPI: CoreDataAPI { get }
    
    func performFetch<T: NSFetchRequestResult>(fetchedResultsController: NSFetchedResultsController<T>)
    func getMovie(with objectID : NSManagedObjectID) -> Movie?
}

final class FavoriteMoviesService {
    
    // MARK: - Variables
    let coreDataAPI: CoreDataAPI
    
    // MARK: - Init
    init(coreDataAPI: CoreDataAPI) {
        self.coreDataAPI = coreDataAPI
    }
}

extension FavoriteMoviesService: FavoriteMoviesServiceProtocol {
    func performFetch<T: NSFetchRequestResult>(fetchedResultsController: NSFetchedResultsController<T>) {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func getMovie(with objectID: NSManagedObjectID) -> Movie? {
        do {
            return try self.coreDataAPI.object(with: objectID) as? Movie
        } catch {
            fatalError("Failed to get movie with error: \(error)")
        }
    }
}
