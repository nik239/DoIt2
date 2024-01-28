//
//  ListSelectionCoordinator.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 03/01/2024.
//

import UIKit

final class ToDosCoordinator: Coordinator {
  var children: [Coordinator] = []
  let router: Router
  let list: ToDoItemList
  let viewController: ToDosViewController

  init(router: Router, list: ToDoItemList) {
    self.list = list
    self.router = router
    self.viewController = ToDosViewController(style: .plain, currentList: list)
    viewController.delegate = self
  }
  
  func present(animated: Bool,
               onDismissed: (() -> Void)?){
    router.present(viewController, animated: animated)
  }
}

// MARK: -ToDosViewControllerDelegate
extension ToDosCoordinator: ToDosViewControllerDelegate {
  func toDosViewControllerDidPressAdd(currentList: ToDoItemList) {
    let router = NewObjectRouter(parentViewController: viewController)
    let coordinator = NewToDoCoordinator(router: router, currentList: list)
    presentChild(coordinator, animated: true)
  }
}
