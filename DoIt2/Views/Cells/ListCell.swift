//
//  ListCell.swift
//  DoIt
//
//  Created by Nikita Ivanov on 11/06/2023.
//

import UIKit
import SnapKit

class ListCell: UITableViewCell {
    lazy var lblDescription: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.text = "list 0"
        lbl.numberOfLines = 0
        self.contentView.addSubview(lbl)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) isn't implemented")
    }
}

//MARK: SnapKit Constraints
extension ListCell {
    func setupConstraints() {
        lblDescription.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().labeled("list-cell horizontal")
            make.top.bottom.equalToSuperview().inset(10).labeled("list-cell vertical")
        }
    }
}
