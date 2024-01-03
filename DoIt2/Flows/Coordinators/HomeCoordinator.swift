//
//  HomeCoordinator.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 03/01/2024.
//

import UIKit

public class HomeCoordinator: Coordinator {

  // MARK: - Instance Properties
  var children: [Coordinator] = []
  let router: Router

  // MARK: - Object Lifecycle
  init(router: Router) {
    self.router = router
  }

  // MARK: - Instance Methods
  public func present(animated: Bool,
                      onDismissed: (() -> Void)?) {
    let listsViewController = ListsViewController()
    listsViewController.delegate = self
    let viewController =
    UINavigationController(rootViewController: listsViewController)
//    viewController.delegate = self
    router.present(viewController,
                   animated: animated,
                   onDismissed: onDismissed)
  }
}

// MARK: - HomeViewControllerDelegate
extension HomeCoordinator: ListsViewControllerDelegate {
  func listsViewControllerDidSelectList(
    _ viewController: ListsViewController, list: ToDoItemList) {
//    let router =
//      ModalNavigationRouter(parentViewController: viewController)
//    let coordinator =
//      PetAppointmentBuilderCoordinator(router: router)
//    presentChild(coordinator, animated: true)
  }
}
