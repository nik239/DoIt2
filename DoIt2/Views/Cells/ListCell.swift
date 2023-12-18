//
//  ListCell.swift
//  DoIt
//
//  Created by Nikita Ivanov on 11/06/2023.
//

import UIKit
import SnapKit

final class ListCell: UITableViewCell {
  lazy var lblTitle: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.textAlignment = .left
    lbl.font = UIFont.systemFont(ofSize: 20)
    lbl.text = "list 0"
    lbl.numberOfLines = 0
    self.contentView.addSubview(lbl)
    return lbl
  }()
  
  lazy var lblNumberOfItems: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.textAlignment = .right
    lbl.text = "(0 items)"
    lbl.font = UIFont.systemFont(ofSize: 20)
    lbl.textColor = .gray
    self.contentView.addSubview(lbl)
    return lbl
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.showsReorderControl = true
    setupConstraints()
  }
  
  required init?(coder: NSCoder){
    fatalError("init(coder:) isn't implemented")
  }
}

//MARK: SnapKit Constraints
extension ListCell {
  func setupConstraints() {
    lblNumberOfItems.snp.makeConstraints{ make in
      make.trailing.equalToSuperview().inset(15).labeled("ListCell NumberOfItems horizontal")
      make.top.bottom.equalToSuperview().inset(10).labeled("ListCell NumberOfItems vertical")
    }
    lblTitle.snp.makeConstraints{ make in
      make.leading.equalToSuperview().inset(15).labeled("list-cell horizontal")
      make.top.bottom.equalToSuperview().inset(10).labeled("list-cell vertical")
    }
  }
}
