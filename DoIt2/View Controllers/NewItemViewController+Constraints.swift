//
//  AddViewController+Constraints.swift
//  DoIt
//
//  Created by Nikita Ivanov on 13/05/2023.
//

import UIKit
import SnapKit

extension NewItemViewController {
    func setupConstraints() {
        lblToDo.snp.makeConstraints{ make in
            make.left.equalToSuperview().labeled("NewItemViewController lblToDo.left")
        }
        svDescription.snp.makeConstraints{ make in
            make.centerX.equalToSuperview().labeled("NewItemViewController svDescritpiton.centerX")
            make.centerY.equalToSuperview().labeled("NewItemViewController scDesctiption.cetnerY")
            //make.height.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.95).labeled("NewItemViewController svDescription.width")
        }
    }
}
