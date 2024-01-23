//
//  TitleLabel.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 05/01/2024.
//

import UIKit

final class TitleLabel: UILabel {
  init(){
    super.init(frame: .zero)
    let model = Model()
    self.textAlignment = model.textAlignment
    self.font = model.font
    self.textColor = model.textColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Model
extension TitleLabel {
  struct Model {
    let textAlignment = NSTextAlignment.center
    let font = UIFont.systemFont(ofSize: 20)
    let textColor = UIColor.systemGray6
  }
}
