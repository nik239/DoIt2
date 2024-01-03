//
//  Router.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 03/01/2024.
//

import UIKit

protocol Router: AnyObject {
  func present(_ viewController: UIViewController, animated: Bool)
  func present(_ viewController: UIViewController,
               animated: Bool,
               onDismissed: (()->Void)?)
  func dismiss(animated: Bool)
}

extension Router {
  func present(_ viewController: UIViewController,
                      animated: Bool) {
    present(viewController, animated: animated, onDismissed: nil)
  }
}

