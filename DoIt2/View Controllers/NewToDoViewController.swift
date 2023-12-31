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
  var toDoPriority: Int16 = 0
  
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
    view.addSubview(lblItemAdded)
    view.addSubview(svPriority)
    view.addSubview(svTitle)
    view.addSubview(priorityLine)
    fldTitle.delegate = self
    setupConstraints()
  }
  
  lazy var lblItemAdded: NotificationLabel = {
    let lbl = NotificationLabel(frame: .zero)
    lbl.text = "Item added!"
    lbl.textAlignment = .center
    lbl.font = UIFont.systemFont(ofSize: 15)
    lbl.textColor = .black
    lbl.backgroundColor = .white
    lbl.layer.cornerRadius = 7.5
    lbl.clipsToBounds = true
    lbl.alpha = 0
    return lbl
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
    return stackView
  }()
  
  lazy var lblPriority: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.textAlignment = .center
    lbl.font = UIFont.systemFont(ofSize: 20)
    lbl.text = "Priority:"
    lbl.textColor = .systemGray6
    return lbl
  }()
  
  lazy var scPriority: UISegmentedControl = {
    let sc = UISegmentedControl(frame: .zero)
    sc.insertSegment(withTitle: "None", at: 0, animated: false)
    sc.insertSegment(withTitle: "Low", at: 1, animated: false)
    sc.insertSegment(withTitle: "Medium", at: 2, animated: false)
    sc.insertSegment(withTitle: "High" , at: 3, animated: false)
    sc.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    sc.selectedSegmentIndex = 0
    return sc
  }()
  
  lazy var svPriority: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [lblPriority, scPriority])
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    return stackView
  }()
  
  lazy var priorityLine: UIView = {
    let pl = PriorityLineView()
    return pl
  }()
  
  @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 1:
      toDoPriority = Priorities.low.rawValue
    case 2:
      toDoPriority = Priorities.medium.rawValue
    case 3:
      toDoPriority = Priorities.high.rawValue
    default:
      break
    }
  }
}

//MARK: TextFieldDelegate
extension NewToDoViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = fldTitle.text, text != "" {
      ToDoItem.createWith(taskDescription: text, list: currentList, priority: toDoPriority)
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
