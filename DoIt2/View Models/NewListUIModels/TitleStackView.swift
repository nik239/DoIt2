//
//  TitleStackView.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 05/01/2024.
//

import UIKit

final class TitleStackView: UIStackView {
  init(arrangedSubviews: [UIView]){
    super.init(frame: .zero)
    self.addArrangedSubviews(arrangedSubviews)
    let model = Model()
    self.alignment = model.alignment
    self.axis = model.axis
    self.distribution = model.distribution
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addArrangedSubviews(_ views: [UIView]) {
    for view in views {
      self.addArrangedSubview(view)
    }
  }
}

// MARK: - Model
extension TitleStackView {
  struct Model {
    let alignment = UIStackView.Alignment.center
    let axis = NSLayoutConstraint.Axis.horizontal
    let distribution = UIStackView.Distribution.fillProportionally
  }
}
