//
//  Priorities.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 24/01/2024.
//

import UIKit

enum Priorities: Int16, CaseIterable {
  case none, low, medium, high
  
  var color: UIColor {
    switch self {
    case .none:
      return .gray
    case .low:
      return .green
    case .medium:
      return .yellow
    case .high:
      return .red
    }
  }
}
