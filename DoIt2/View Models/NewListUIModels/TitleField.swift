//
//  TitleField.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 05/01/2024.
//

import UIKit

final class TitleField: UITextField {
  init(){
    super.init(frame: .zero)
    let model = Model()
    self.textAlignment = model.textAlignment
    self.borderStyle = model.borderStyle
    self.backgroundColor = model.backgroundColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Model
extension TitleField {
  struct Model {
    let textAlignment = NSTextAlignment.left
    let borderStyle = UITextField.BorderStyle.roundedRect
    let backgroundColor = UIColor.systemGray6
  }
}
