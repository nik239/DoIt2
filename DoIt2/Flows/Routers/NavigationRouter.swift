//
//  NavigationRouter.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 03/01/2024.
//

import UIKit

public class NavigationRouter: NSObject {
  let navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    super.init()
  }
}

// MARK: - Router
extension NavigationRouter: Router {
  public func present(_ viewController: UIViewController,
                      animated: Bool,
                      onDismissed: (() -> Void)?) {
    navigationController.pushViewController(viewController, animated: animated)
  }

  public func dismiss(animated: Bool) {
    // do nothing
  }
}
