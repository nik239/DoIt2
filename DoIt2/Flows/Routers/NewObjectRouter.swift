//
//  NewItemRouter.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 04/01/2024.
//

import UIKit

final class NewObjectRouter: Router {
  let parentViewController: (UIViewController & UIViewControllerTransitioningDelegate)
  
  init(parentViewController: (UIViewController & UIViewControllerTransitioningDelegate)){
    self.parentViewController = parentViewController
  }
  
  func present(_ viewController: UIViewController,
               animated: Bool,
               onDismissed: (() -> Void)?) {
    viewController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
    viewController.preferredContentSize = CGSize(width: 600, height: 300)
    viewController.transitioningDelegate = parentViewController
    parentViewController.present(viewController, animated: true, completion: nil)
  }
  func dismiss(animated: Bool) {
    //do nothing
  }
}
