//
//  FavoriteMoviesCoordinator.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-19.
//

import UIKit

protocol FavoriteMoviesCoordinatorProtocol: Coordinator {
    func showFavoriteMoviesViewController(animated: Bool)
}

final class FavoriteMoviesCoordinator: FavoriteMoviesCoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    var type: CoordinatorType { .favoriteMovies }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {
        showFavoriteMoviesViewController(animated: animated)
    }
    
    deinit {
        print("Removed \(self) coordinator from memory")
    }
    
    func showFavoriteMoviesViewController(animated: Bool = true) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("Couldn't find scene")
        }
        
        guard let coreDataAPI = sceneDelegate.coreDataAPI else {
            fatalError("Couldn't create coreDataAPI")
        }
        
        let favoriteMoviesService = FavoriteMoviesService(coreDataAPI: coreDataAPI)
        let viewModel = FavoriteMoviesViewModel(favoriteMoviesService: favoriteMoviesService)
        let favoritesVC = FavoriteMoviesViewController(viewModel: viewModel)
        
        navigationController.pushViewController(favoritesVC, animated: animated)
    }
}
