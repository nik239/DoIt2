//
//  AddViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 13/05/2023.
//

import UIKit
import SnapKit

final class NewToDoViewController: UIViewController {
  private let model: NewToDoViewModel
  private let currentList: ToDoItemList
  var persistenceManager: PersistenceManager = PersistenceManager.shared
  
  init(currentList: ToDoItemList){
    self.model = NewToDoViewModel()
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
    view.addSubview(lblItemAdded)
    view.addSubview(svPriority)
    view.addSubview(svTitle)
    view.addSubview(priorityLine)
    fldTitle.delegate = self
    setupConstraints()
  }
  
  lazy var lblItemAdded: NotificationLabel = {
    let lbl = NotificationLabel()
    return lbl
  }()
  
  lazy var lblInstructions: InstructionsLabel = {
    let lbl = InstructionsLabel()
    lbl.text = """
    To create a new to-do enter a title and press return.
    To cancel swipe down.
    """
    return lbl
  }()
  
  lazy var lblTitle: TitleLabel = {
    let lbl = TitleLabel()
    lbl.text = "Name:"
    return lbl
  }()
  
  lazy var fldTitle: TitleField = {
    let fld = TitleField()
    fld.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
    fld.placeholder = "Enter to-do description"
    return fld
  }()
  
  lazy var svTitle: TitleStackView = {
    let sv = TitleStackView(arrangedSubviews: [lblTitle, fldTitle])
    return sv
  }()
  
  lazy var lblPriority: TitleLabel = {
    let lbl = TitleLabel()
    lbl.text = "Priority:"
    return lbl
  }()
  
  lazy var scPriority: PriorityControl = {
    let sc = PriorityControl()
    sc.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    sc.selectedSegmentIndex = 0
    return sc
  }()
  
  lazy var svPriority: TitleStackView = {
    let sv = TitleStackView(arrangedSubviews: [lblPriority, scPriority])
    return sv
  }()
  
  lazy var priorityLine: PriorityLineView = {
    let pl = PriorityLineView()
    return pl
  }()
  
  @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    model.setPriority(index: sender.selectedSegmentIndex)
  }
}

//MARK: TextFieldDelegate
extension NewToDoViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = fldTitle.text, text != "" {
      persistenceManager.createToDoItem(taskDescription: text, list: currentList, priority: model.toDoPriority)
      fldTitle.text = ""
    }
    UIView.animate(withDuration: 0.3) {
      self.lblItemAdded.alpha = 1
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
      UIView.animate(withDuration: 0.3) {
        self.lblItemAdded.alpha = 0
      }
    }
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
    lblItemAdded.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(30)
      make.centerX.equalToSuperview()
    }
    lblTitle.snp.makeConstraints { make in
      make.width.equalTo(60).labeled("NewToDoViewController lblTitle.width")
    }
    svTitle.snp.makeConstraints{ make in
      make.width.equalToSuperview().multipliedBy(0.95).labeled("NewToDoViewController svTitle.width")
      make.centerX.equalToSuperview().labeled("NewToDoViewController svTitle.centerX")
      make.centerY.equalToSuperview().labeled("NewToDoViewController svTitle.cetnerY")
    }
    svPriority.snp.makeConstraints { make in
      make.width.equalToSuperview().multipliedBy(0.95).labeled("NewToDoViewController svTitle.width")
      make.centerX.equalToSuperview()
      make.bottom.equalTo(svTitle).inset(50)
    }
    priorityLine.snp.makeConstraints { make in
      make.width.equalTo(scPriority)
      make.height.equalTo(3)
      make.centerX.equalTo(scPriority)
      make.bottom.equalTo(svPriority).inset(30)
    }
  }
}
