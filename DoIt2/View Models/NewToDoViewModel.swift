//
//  NewToDoViewModel.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 23/01/2024.
//

import UIKit

struct NewToDoViewModel {
  let currentList: ToDoItemList
  var toDoPriority: Int16 = 0
  
  mutating func setPriority(sender: UISegmentedControl){
    switch sender.selectedSegmentIndex {
    case 1:
      toDoPriority = Priorities.low.rawValue
    case 2:
      toDoPriority = Priorities.medium.rawValue
    case 3:
      toDoPriority = Priorities.high.rawValue
    default:
      break
    }
  }
}
