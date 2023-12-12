//
//  AddViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 13/05/2023.
//

import UIKit
import SnapKit

final class NewToDoViewController: UIViewController {
  let currentList: ToDoItemList
  
  init(currentList: ToDoItemList){
    self.currentList = currentList
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder){
    fatalError("init(coder:) isn't implemented")
  }
  
  lazy var fldDescription: UITextField = {
    let fld = UITextField(frame: .zero)
    fld.textAlignment = .left
    fld.textColor = .white
    fld.placeholder = "Description"
    
    return fld
  }()
  
  lazy var lblToDo: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.textAlignment = .center
    lbl.font = UIFont.systemFont(ofSize: 20)
    lbl.text = "New to-do:"
    
    return lbl
  }()
  
  lazy var svDescription: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [lblToDo, fldDescription])
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    
    //view.addSubview(stackView)
    
    return stackView
  }()
  
  lazy var saveButton: UIBarButtonItem = {
    //do this setup in View Model
    let btn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
    return btn
  }()
  
  @objc func saveButtonTapped() {
    guard let text = fldDescription.text else {
      return
    }
    ToDoItem.createWith(taskDescription: text, list: currentList)
    navigationController?.popViewController(animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(svDescription)
    navigationItem.rightBarButtonItem = saveButton
    fldDescription.delegate = self
    setupConstraints()
  }
}

extension NewToDoViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

//MARK: SnapKit Constraints
extension NewToDoViewController {
  func setupConstraints() {
    lblToDo.snp.makeConstraints{ make in
      make.left.equalToSuperview().labeled("NewToDoViewController lblToDo.left")
    }
    svDescription.snp.makeConstraints{ make in
      make.centerX.equalToSuperview().labeled("NewToDoViewController svDescritpiton.centerX")
      make.centerY.equalToSuperview().labeled("NewToDoViewController scDesctiption.cetnerY")
      //make.height.equalTo(20)
      make.width.equalToSuperview().multipliedBy(0.95).labeled("NewToDoViewController svDescription.width")
    }
  }
}
