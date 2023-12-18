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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    view.backgroundColor = .systemGray2
    view.addSubview(lblInstructions)
    view.addSubview(svItemAdded)
    view.addSubview(svTitle)
    fldTitle.delegate = self
    setupConstraints()
  }
  
  lazy var imgItemAdded: UIImageView = {
    let img = UIImage(systemName: "checkmark.circle.fill")!
    img.withTintColor(.green)
    let imgView = UIImageView(image: img)
    return imgView
  }()
  
  lazy var lblItemAdded: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.text = "New to-do was created!"
    lbl.font = UIFont.systemFont(ofSize: 20)
    lbl.textColor = .black
    return lbl
  }()
  
  lazy var svItemAdded: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [imgItemAdded, lblItemAdded])
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.backgroundColor = .white
    
    return stackView
  }()
  
  lazy var lblInstructions: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.numberOfLines = 0
    lbl.text = """
    To create a new to-do enter a title and press return.
    To cancel swipe down.
    """
    lbl.font = UIFont.preferredFont(forTextStyle: .footnote)
    lbl.textColor = .systemGray6
    return lbl
  }()
  
  lazy var lblTitle: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.textAlignment = .center
    lbl.font = UIFont.systemFont(ofSize: 20)
    lbl.text = "Name:"
    lbl.textColor = .systemGray6
    return lbl
  }()
  
  lazy var fldTitle: UITextField = {
    let fld = UITextField(frame: .zero)
    fld.textAlignment = .left
    fld.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
    fld.borderStyle = .roundedRect
    fld.backgroundColor = .systemGray6
    fld.placeholder = "Enter to-do description"
    return fld
  }()
  
  lazy var svTitle: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [lblTitle, fldTitle])
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    view.addSubview(stackView)
    
    return stackView
  }()
  
}

extension NewToDoViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = fldTitle.text, text != "" {
      ToDoItem.createWith(taskDescription: text, list: currentList)
      fldTitle.text = ""
    }
    textField.resignFirstResponder()
    return true
  }
}

//MARK: SnapKit Constraints
extension NewToDoViewController {
  func setupConstraints() {
    lblInstructions.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(30)
      make.centerX.equalToSuperview()
    }
    imgItemAdded.snp.makeConstraints { make in
      make.width.equalTo(20)
      make.height.equalTo(20)
    }
    lblItemAdded.snp.makeConstraints { make in
  //    make.centerX.equalToSuperview()
    }
    svItemAdded.snp.makeConstraints{ make in
      make.top.equalToSuperview().inset(30)
      make.centerX.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.85)
    }
    lblTitle.snp.makeConstraints { make in
      make.width.equalTo(60).labeled("NewToDoViewController lblTitle.width")
    }
    svTitle.snp.makeConstraints{ make in
      make.width.equalToSuperview().multipliedBy(0.95).labeled("NewToDoViewController svTitle.width")
      make.centerX.equalToSuperview().labeled("NewToDoViewController svTitle.centerX")
      make.centerY.equalToSuperview().labeled("NewToDoViewController svTitle.cetnerY")
    }
  }
}
