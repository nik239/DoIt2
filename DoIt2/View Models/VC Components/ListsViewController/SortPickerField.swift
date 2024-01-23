//
//  SortPicker.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 06/01/2024.
//

import UIKit

final class SortPickerField: UITextField {
  init(inputView: UIPickerView, placeholder: String){
    super.init(frame: .zero)
    let model = Model()
    self.inputView = inputView
    self.placeholder = placeholder
    self.borderStyle = model.borderStyle
    self.textAlignment = model.textAlignment
    self.font = model.font
    self.tintColor = model.tintColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Model
extension SortPickerField {
  struct Model {
    let borderStyle = UITextField.BorderStyle.roundedRect
    let textAlignment = NSTextAlignment.center
    let font = UIFont.boldSystemFont(ofSize: 20)
    let tintColor = UIColor.clear
  }
}
