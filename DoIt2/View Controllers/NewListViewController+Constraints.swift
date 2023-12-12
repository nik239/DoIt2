//
//  NewListViewController+Constraints.swift
//  DoIt
//
//  Created by Nikita Ivanov on 11/06/2023.
//

import UIKit
import SnapKit

extension NewListViewController {
    func setupConstraints() {
        lblTitle.snp.makeConstraints{ make in
            make.left.equalToSuperview().labeled("NewListViewController lblTitle.left")
        }
        svTitle.snp.makeConstraints{ make in
            make.centerX.equalToSuperview().labeled("NewListViewController svTitle.centerX")
            make.centerY.equalToSuperview().labeled("NewListViewController svTitle.cetnerY")
            //make.height.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.95).labeled("NewListViewController svTitle.width")
        }
        btnSave.snp.makeConstraints{ make in
            make.centerX.equalToSuperview().labeled("NewListViewController btnSave.centerX")
            make.bottom.equalToSuperview().inset(20).labeled("NewListViewController btnSave.bottom")
        }
    }
}
