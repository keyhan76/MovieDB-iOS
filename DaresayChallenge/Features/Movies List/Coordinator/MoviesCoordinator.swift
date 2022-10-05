//
//  MoviesCoordinator.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-27.
//

import UIKit
import SwiftUI

protocol MoviesCoordinatorProtocol: Coordinator {
    func showMoviesViewController(animated: Bool)
    func showMovieDetailViewController(with movie: Movie, animated: Bool)
}

final class MoviesCoordinator: MoviesCoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    var type: CoordinatorType { .movies }
    
    var coreDataAPI: CoreDataAPI {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("Couldn't find scene")
        }
        
        guard let coreDataAPI = sceneDelegate.coreDataAPI else {
            fatalError("Couldn't create coreDataAPI")
        }
        
        return coreDataAPI
    }
    
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
        
        let service = MoviesService(serverManager: MovieServer.shared, coreDataAPI: coreDataAPI)
        let viewModel = MoviesViewModel(moviesService: service)
        
        let moviesVC = MoviesViewController(viewModel: viewModel)
        
        moviesVC.didSendEventClosure = { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .movieDetail(let selectedMovie):
                self.showMovieDetailViewController(with: selectedMovie)
            }
        }
        
        navigationController.pushViewController(moviesVC, animated: animated)
    }
    
    func showMovieDetailViewController(with movie: Movie, animated: Bool = true) {
        
        let movieDetailService = MovieDetailService(coreDataAPI: coreDataAPI)
        let viewModel = MovieDetailViewModel(movieDetailService: movieDetailService, selectedMovie: movie)

        let movieDetailView = UIHostingController(rootView: MovieDetailView(viewModel: viewModel))
        movieDetailView.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(movieDetailView, animated: animated)
    }
}
