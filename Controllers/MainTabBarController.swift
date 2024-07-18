//
//  MainTabBarController.swift
//  quakealert
//
//  Created by EMTECH MAC on 03/07/2024.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    private func setupViewControllers() {
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)

        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "list.bullet"), tag: 1)

        viewControllers = [mapViewController, feedViewController]
    }
}
