//
//  SceneDelegate.swift
//  DoIt
//
//  Created by Nikita Ivanov on 12/05/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
    window?.rootViewController = UINavigationController(rootViewController: ListsViewController())
    window?.makeKeyAndVisible()
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    PersistenceController.shared.saveContext()
  }
}

