//
//  NewToDoViewModel.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 23/01/2024.
//

import UIKit

final class NewToDoViewModel {
  var toDoPriority: Int16 = 0
  
  func setPriority(index: Int){
    switch index {
    case 1:
      toDoPriority = Priorities.low.rawValue
    case 2:
      toDoPriority = Priorities.medium.rawValue
    case 3:
      toDoPriority = Priorities.high.rawValue
    default:
      toDoPriority = Priorities.none.rawValue
    }
  }
}
