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
  
  lazy var lblInstructions: InstructionsLabel = {
    let lbl = InstructionsLabel()
    lbl.text = """
    To create a new list enter a title and press return.
    To cancel swipe down.
    """
    return lbl
  }()
  
  lazy var lblTitle: TitleLabel = {
    let lbl = TitleLabel()
    lbl.text = "Title:"
    return lbl
  }()
  
  lazy var fldTitle: TitleField = {
    let fld = TitleField()
    fld.placeholder = "Enter list title"
    fld.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
    return fld
  }()
  
  lazy var svTitle: TitleStackView = {
    let sv = TitleStackView(arrangedSubviews: [lblTitle, fldTitle])
    return sv
  }()
}

// MARK: - UITextFieldDelegate
extension NewListViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = fldTitle.text, text != "" else {
      textField.resignFirstResponder()
      return true
    }
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
