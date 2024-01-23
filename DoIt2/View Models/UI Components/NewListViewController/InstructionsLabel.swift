//
//  UILabelModel.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 02/01/2024.
//

import UIKit

final class InstructionsLabel: UILabel {
  init() {
    super.init(frame: .zero)
    let model = Model()
    self.numberOfLines = model.numberOfLines
    self.font = model.font
    self.textColor = model.textColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Model
extension InstructionsLabel {
  struct Model {
    let numberOfLines = 0
    let font = UIFont.preferredFont(forTextStyle: .footnote)
    let textColor = UIColor.systemGray6
  }
}

