//
//  UILabelModel.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 02/01/2024.
//

import Foundation
import UIKit

final class MyUILabel: UILabel {
  init(model: Model) {
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension MyUILabel {
  struct Model {
    
  }
}
