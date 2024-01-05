//
//  PriorityControl.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 05/01/2024.
//

import UIKit

final class PriorityControl: UISegmentedControl {
  init() {
    super.init(frame: .zero)
    self.insertSegment(withTitle: "None", at: 0, animated: false)
    self.insertSegment(withTitle: "Low", at: 1, animated: false)
    self.insertSegment(withTitle: "Medium", at: 2, animated: false)
    self.insertSegment(withTitle: "High" , at: 3, animated: false)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
