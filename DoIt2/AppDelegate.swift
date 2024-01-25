//
//  AppDelegate.swift
//  DoIt
//
//  Created by Nikita Ivanov on 12/05/2023.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  private lazy var coordinator = HomeCoordinator(router: router)
  private lazy var router = AppDelegateRouter(window: window!)
  public lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    coordinator.present(animated: true, onDismissed: nil)
    return true
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    PersistenceManager.shared.saveContext()
  }
}

