//
//  NewListViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 11/06/2023.
//

import UIKit
import SnapKit

final class NewListViewController: UIViewController {
  let updateListViewController: () -> ()
  init(update: @escaping () -> ()){
    self.updateListViewController = update
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) isn't implemented")
  }
  lazy var fldTitle: UITextField = {
    let fld = UITextField(frame: .zero)
    fld.textAlignment = .left
    fld.textColor = .white
    fld.placeholder = "List title..."
    
    return fld
  }()
  
  lazy var lblTitle: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.textAlignment = .center
    lbl.font = UIFont.systemFont(ofSize: 20)
    lbl.text = "List title:"
    
    return lbl
  }()
  
  lazy var svTitle: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [lblTitle, fldTitle])
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    view.addSubview(stackView)
    
    return stackView
  }()
  
  lazy var btnSave: UIButton = {
    let btn = UIButton(type: .system) // Creates a standard system button (blue text, no background)
    btn.setTitle("Save", for: .normal)
    btn.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    return btn
  }()
  
  @objc func saveButtonTapped() {
    guard let text = fldTitle.text else {
      return
    }
    ToDoItemList.createWith(title: text)
    updateListViewController()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(svTitle)
    view.addSubview(btnSave)
    fldTitle.delegate = self
    setupConstraints()
  }
}

extension NewListViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

//MARK: SnapKit Constraints
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
