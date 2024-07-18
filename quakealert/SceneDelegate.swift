//
//  SceneDelegate.swift
//  quakealert
//
//  Created by EMTECH MAC on 18/07/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let mainTabbarController = MainTabbarController()
        window?.rootViewController = mainTabbarController
        window?.makeKeyAndVisible()
    }
}


