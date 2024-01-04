//
//  NewObjectCoordinator.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 04/01/2024.
//

import UIKit

final class NewListCoordinator: Coordinator {
  var children: [Coordinator] = []
  let router: Router
  
  init(router: Router) {
    self.router = router
  }
  
  func present(animated: Bool, onDismissed: (() -> Void)?) {
    router.present(NewListViewController(), animated: true)
  }
}
