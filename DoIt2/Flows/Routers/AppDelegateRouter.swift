//
//  AppDelegateRouter.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 03/01/2024.
//

import UIKit

class AppDelegateRouter: Router {
  let window: UIWindow
  
  init(window: UIWindow) {
    self.window = window
  }
  
  // MARK: - Router
  func present(_ viewController: UIViewController,
               animated: Bool,
               onDismissed: (()->Void)?) {
    window.rootViewController = viewController
    window.makeKeyAndVisible()
  }
  
  func dismiss(animated: Bool) {
    // do nothing
  }
}
