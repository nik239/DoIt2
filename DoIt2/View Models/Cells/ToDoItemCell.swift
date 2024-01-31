//
//  TaskCell.swift
//  DoIt
//
//  Created by Nikita Ivanov on 13/05/2023.
//

import UIKit
import SnapKit

class ToDoItemCell: UITableViewCell {
  lazy var lblDescription: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.textAlignment = .left
    lbl.font = UIFont.systemFont(ofSize: 20)
    lbl.text = "task 0"
    lbl.numberOfLines = 0
    return lbl
  }()
  
  lazy var imgvPriority: UIImageView = {
    let img = UIImage(systemName: "square.fill")!
    let imgv = UIImageView(image: img)
    imgv.tintColor = Priorities.none.color
    return imgv
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(lblDescription)
    contentView.addSubview(imgvPriority)
    setupConstraints()
  }
  
  required init?(coder: NSCoder){
    fatalError("init(coder:) isn't implemented")
  }
}

//MARK: SnapKit Constraints
extension ToDoItemCell {
  func setupConstraints() {
    imgvPriority.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(15)
      make.centerY.equalToSuperview()
    }
    lblDescription.snp.makeConstraints{ make in
      make.leading.equalToSuperview().inset(15)
      make.centerY.equalToSuperview()
      make.trailing.equalTo(imgvPriority)
      make.top.bottom.equalToSuperview().inset(15).labeled("label-cell vertical")
    }
  }
}
