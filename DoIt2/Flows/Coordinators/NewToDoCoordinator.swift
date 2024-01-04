//
//  NewToDoCoordinator.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 04/01/2024.
//

import UIKit

final class NewToDoCoordinator: Coordinator {
  var children: [Coordinator] = []
  let router: Router
  let currentList: ToDoItemList
  
  init(router: Router, currentList: ToDoItemList) {
    self.currentList = currentList
    self.router = router
  }
  
  func present(animated: Bool, onDismissed: (() -> Void)?) {
    router.present(NewToDoViewController(currentList: currentList), animated: true)
  }
}
