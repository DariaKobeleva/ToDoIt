//
//  SceneDelegate.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 18.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let todoModule = TodoRouter.createModule()
        
        let navigationController = UINavigationController(rootViewController: todoModule)
        
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.barTintColor = .black
        navigationController.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

