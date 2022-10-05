//
//  FavoriteMoviesViewModel.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-29.
//

import Foundation
import CoreData
import UIKit

final class FavoriteMoviesViewModel {
    
    // MARK: - Variables
    public weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    public lazy var fetchedResultsController: NSFetchedResultsController<Movie> = {
        let isFavorite = NSNumber(booleanLiteral: true)
        let predicate = NSPredicate(format: "isFavorite == %@", isFavorite)
        return favoriteMoviesService.coreDataAPI.createFetchResultsController(entity: Movie.self, predicate: predicate, delegate: fetchedResultsControllerDelegate)
    }()
    
    private let favoriteMoviesService: FavoriteMoviesServiceProtocol

    // MARK: - Init
    init(favoriteMoviesService: FavoriteMoviesServiceProtocol) {
        self.favoriteMoviesService = favoriteMoviesService
    }
    
    // MARK: - Public methods
    func createDiffableDataSource(for tableView: UITableView) -> UITableViewDiffableDataSource<Section, NSManagedObjectID> {
        
        let cellIdentifier = String(describing: MovieTableViewCell.self)
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        let diffableDataSource = UITableViewDiffableDataSource<Section, NSManagedObjectID>(tableView: tableView) { [weak self] tableView, indexPath, objectID in
            
            guard let self = self else { fatalError() }
            
            let movieObject = self.favoriteMoviesService.getMovie(with: objectID)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieTableViewCell else {
                return UITableViewCell()
            }
            
            if let movie = movieObject {
                cell.configureCellWith(movie)
            }
            
            return cell
        }
        
        return diffableDataSource
    }
    
    func performFetch() {
        favoriteMoviesService.performFetch(fetchedResultsController: fetchedResultsController)
    }
}
