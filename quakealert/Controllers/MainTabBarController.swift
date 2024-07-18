//
//  MainTabBarController.swift
//  quakealert
//
//  Created by EMTECH MAC on 18/07/2024.
//

import UIKit

class MainTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)
        
        let searchViewController = SearchViewController(viewModel: EarthquakeViewModel(apiManager: APIManager()))
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        searchNavigationController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        viewControllers = [mapViewController, searchNavigationController]
    }
}

