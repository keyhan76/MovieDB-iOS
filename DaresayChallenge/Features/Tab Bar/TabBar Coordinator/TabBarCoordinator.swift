//
//  TabBarCoordinator.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-19.
//

import UIKit

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: TabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
}

enum TabBarPage {
    case home
    case bookmarks
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .bookmarks
        default: return nil
        }
    }
    
    var pageTitle: String {
        switch self {
        case .home:
            return "Home"
        case .bookmarks:
            return "Saved"
        }
    }
    
    var pageOrderNumber: Int {
        switch self {
        case .home:
            return 0
        case .bookmarks:
            return 1
        }
    }
    
    var pageIcon: UIImage {
        switch self {
        case .home:
            return UIImage(systemName: "house")!
        case .bookmarks:
            return UIImage(systemName: "bookmark")!
        }
    }
}

class TabCoordinator: NSObject, TabCoordinatorProtocol {
    
    var tabBarController: TabBarController
    
    var navigationController: UINavigationController
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: Coordinator?
    
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = TabBarController()
    }
    
    deinit {
        print("TabCoordinator deinit")
    }
    
    func start(animated: Bool) {
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage] = [.home, .bookmarks]
            .sorted(by: { $0.pageOrderNumber < $1.pageOrderNumber })
        
        // Initialization of ViewControllers or these pages
        let tabControllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        tabBarController.prepareTabBarController(with: tabControllers, navigationController: navigationController, animated: animated)
    }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber
    }
    
    func currentPage() -> TabBarPage? {
        TabBarPage.init(index: tabBarController.selectedIndex)
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = tabBarController.createTabController(page)

        switch page {
        case .home:
            let moviesCoordinator = MoviesCoordinator(navController)
            
            moviesCoordinator.parentCoordinator = self
            childCoordinators.append(moviesCoordinator)
            moviesCoordinator.start()
        case .bookmarks:
            let favMoviesCoordinator = FavoriteMoviesCoordinator(navController)
            
            favMoviesCoordinator.parentCoordinator = self
            childCoordinators.append(favMoviesCoordinator)
            
            favMoviesCoordinator.start()
        }
        
        return navController
    }
}
