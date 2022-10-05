//
//  TabBarController.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-19.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    public func prepareTabBarController(with tabControllers: [UIViewController], navigationController: UINavigationController, animated: Bool) {
        
        // Assign page's controllers
        setViewControllers(tabControllers, animated: animated)
        
        // Let set index
        selectedIndex = TabBarPage.home.pageOrderNumber
        
        // Attach tabBarController to navigation controller associated with this coordinator
        navigationController.viewControllers = [self]
        
    }
    
    public func createTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()

        navController.tabBarItem = UITabBarItem.init(title: page.pageTitle,
                                                     image: page.pageIcon,
                                                     tag: page.pageOrderNumber)
        
        return navController
    }
}
