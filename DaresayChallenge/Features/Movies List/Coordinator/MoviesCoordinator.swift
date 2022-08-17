//
//  MoviesCoordinator.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-27.
//

import UIKit

protocol MoviesCoordinatorProtocol: Coordinator {
    func showMoviesViewController(animated: Bool)
}

final class MoviesCoordinator: MoviesCoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    var type: CoordinatorType { .movies }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {
        showMoviesViewController(animated: animated)
    }
    
    deinit {
        print("Removed \(self) coordinator from memory")
    }
    
    func showMoviesViewController(animated: Bool = true) {
        let moviesVC = MoviesViewController()
        
        moviesVC.didSendEventClosure = { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .movieDetail(let selectedMovie):
                self.showMovieDetailViewController(viewController: moviesVC, with: selectedMovie)
            case .favorites:
                self.showFavoriteMoviesViewController()
            }
        }
        
        navigationController.pushViewController(moviesVC, animated: animated)
    }
    
    func showMovieDetailViewController(viewController: ReloadFavoritesDelegate, with movie: MoviesModel, animated: Bool = true) {
        let movieDetailVC = MovieDetailViewController(selectedMovie: movie)
        
        // Set delegate
        movieDetailVC.delegate = viewController
        
        navigationController.pushViewController(movieDetailVC, animated: animated)
    }
    
    func showFavoriteMoviesViewController(animated: Bool = true) {
        let favoritesVC = FavoriteMoviesViewController()
        
        navigationController.pushViewController(favoritesVC, animated: animated)
    }
}
