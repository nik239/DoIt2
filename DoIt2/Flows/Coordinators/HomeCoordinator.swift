//
//  HomeCoordinator.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 03/01/2024.
//

import UIKit

final class HomeCoordinator: Coordinator {
  var children: [Coordinator] = []
  let router: Router
  let navigationController = UINavigationController()

  init(router: Router) {
    self.router = router
  }

  func present(animated: Bool,
                      onDismissed: (() -> Void)?) {
    let listsViewController = ListsViewController()
    listsViewController.delegate = self
    navigationController.setViewControllers([listsViewController], animated: false)
    router.present(navigationController,
                   animated: animated,
                   onDismissed: onDismissed)
  }
}

// MARK: - ListsViewControllerDelegate
extension HomeCoordinator: ListsViewControllerDelegate {
  func listsViewControllerDidSelectList(list: ToDoItemList) {
    let router = NavigationRouter(navigationController: navigationController)
    let coordinator = ToDosCoordinator(router: router, list: list)
    presentChild(coordinator, animated: true)
  }
  func listsViewControllerDidPressAdd() {
    let router = NewObjectRouter(parentViewController: navigationController.viewControllers.first as! (UIViewController & UIViewControllerTransitioningDelegate))
    let coordinator = NewListCoordinator(router: router)
    presentChild(coordinator, animated: true)
  }
}
