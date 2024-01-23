//
//  NotificationLabel.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 05/01/2024.
//

import UIKit

final class NotificationLabel: UILabel {
  let model: Model
  
  init(){
    self.model = Model()
    super.init(frame: .zero)
    self.text = model.text
    self.textAlignment = model.textAlignment
    self.font = model.font
    self.textColor = model.textColor
    self.backgroundColor = model.backgroundColor
    self.layer.cornerRadius = model.corenrRadius
    self.clipsToBounds = model.clipsToBounds
    self.alpha = model.alpha 
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: model.textInsets))
  }

  override var intrinsicContentSize: CGSize {
      let size = super.intrinsicContentSize
    return CGSize(width: size.width + model.textInsets.left + model.textInsets.right,
                  height: size.height + model.textInsets.top + model.textInsets.bottom)
  }
}

// MARK: - Model
extension NotificationLabel {
  struct Model {
    var textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    let text = "Item added!"
    let textAlignment = NSTextAlignment.center
    let font = UIFont.systemFont(ofSize: 15)
    let textColor = UIColor.black
    let backgroundColor = UIColor.white
    let corenrRadius: CGFloat = 7.5
    let clipsToBounds = true
    let alpha: CGFloat = 0
  }
}
