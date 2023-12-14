//
//  NewListViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 11/06/2023.
//

import UIKit
import SnapKit

final class NewListViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    view.backgroundColor = .systemGray2
    view.addSubview(lblInstructions)
    view.addSubview(svTitle)
    fldTitle.delegate = self
    setupConstraints()
  }
  
  lazy var lblInstructions: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.numberOfLines = 0
    lbl.text = """
    To create a new list enter a title and press return.
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
    lbl.text = "Title:"
    lbl.textColor = .systemGray6
    return lbl
  }()
  
  lazy var fldTitle: UITextField = {
    let fld = UITextField(frame: .zero)
    fld.textAlignment = .left
    fld.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
    fld.borderStyle = .roundedRect
    fld.backgroundColor = .systemGray6
    fld.placeholder = "Enter list title"
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

extension NewListViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = fldTitle.text, text != "" else {
      textField.resignFirstResponder()
      return true
    }
    print("creating new list!")
    ToDoItemList.createWith(title: text)
    textField.resignFirstResponder()
    self.dismiss(animated: true)
    return true
  }
}

//MARK: SnapKit Constraints
extension NewListViewController {
  func setupConstraints() {
    lblInstructions.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(30)
      make.centerX.equalToSuperview()
    }
    lblTitle.snp.makeConstraints { make in
      make.width.equalTo(60).labeled("NewListViewController lblTitle.width")
    }
    svTitle.snp.makeConstraints{ make in
      make.width.equalToSuperview().multipliedBy(0.95).labeled("NewListViewController svTitle.width")
      make.centerX.equalToSuperview().labeled("NewListViewController svTitle.centerX")
      make.centerY.equalToSuperview().labeled("NewListViewController svTitle.cetnerY")
    }
  }
}
