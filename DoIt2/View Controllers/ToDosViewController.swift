//
//  ViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 12/05/2023.
//

import UIKit

enum Sections: String, CaseIterable {
  case todo = " Current:"
  case finished = " Finished:"
}

final class ToDosViewController: UITableViewController, UIViewControllerTransitioningDelegate {
  private let model: ToDosViewModel
  weak var delegate: ToDosViewControllerDelegate?
  
  init(style: UITableView.Style, currentList: ToDoItemList) {
    model = ToDosViewModel(currentList: currentList)
    super.init(style: style)
  }
  
  required init?(coder: NSCoder){
    fatalError("init(coder:) isn't implemented")
  }
  
  private func setupUI() {
    navigationItem.rightBarButtonItems = [btnAdd, editButtonItem]
    self.navigationItem.leftItemsSupplementBackButton = true
    if let btnBack = navigationItem.leftBarButtonItems {
      navigationItem.leftBarButtonItems = btnBack + [btnSort]
    } else {
      navigationItem.leftBarButtonItems = [btnSort]
    }
    self.navigationItem.title = model.currentList.title
  }
  
  private lazy var btnAdd: UIBarButtonItem = {
    let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    return btn
  }()
  
  @objc func addButtonTapped() {
    guard let delegate = delegate else {
      assertionFailure("Delegate is nil")
      return
    }
    delegate.toDosViewControllerDidPressAdd(currentList: model.currentList)
  }
  
  private lazy var pkrSort: UIPickerView = {
    let pkr = UIPickerView()
    pkr.delegate = self
    pkr.dataSource = self
    return pkr
  }()
  
  private lazy var btnSort: UIBarButtonItem = {
    let btn = UIBarButtonItem(title: "Sort", style: .bordered, target: self, action: #selector(presentSortSelector))
    return btn
  }()
  
  @objc func presentSortSelector() {present(alrtSelectSort, animated: true)}
  
  private lazy var alrtSelectSort: UIAlertController = {
    let alrt = UIAlertController(
      title: "Sort by:",
      message: nil,
      preferredStyle: .alert)
    alrt.addTextField { fld in
      fld.placeholder = self.model.sortSelection.current.rawValue
      fld.borderStyle = .roundedRect
      fld.inputView = self.pkrSort
      fld.textAlignment = .center
      fld.font = UIFont.boldSystemFont(ofSize: 20)
      fld.tintColor = .clear
    }
    let sortAction = UIAlertAction(
      title: "Apply",
      style: .default
    ) {[unowned self] _ in
      guard let dataSource = model.dataSource else {
        assertionFailure("dataSource is nil")
        return
      }
      dataSource.toDosFetch.sort()
    }
    alrt.addAction(sortAction)
    alrt.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    return alrt
  }()
}

//MARK: Life Cycle
extension ToDosViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    model.tableView = tableView
    setupUI()
    setupTableView()
  }
  
  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    UIView.performWithoutAnimation {
      guard let dataSource = model.dataSource else {
        assertionFailure("dataSource is nil")
        return
      }
      dataSource.loadData()
    }
  }
}

//MARK: TableView
extension ToDosViewController {
  private func setupTableView() {
    tableView.register(ToDoItemCell.self, forCellReuseIdentifier: "\(ToDoItemCell.self)\(Sections.todo.rawValue)")
    tableView.register(CompletedToDoItemCell.self, forCellReuseIdentifier: "\(ToDoItemCell.self)\(Sections.finished.rawValue)")
    model.configureDataSource()
    tableView.delegate = self
  }
  
  override func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    let lblSection = UILabel()
    lblSection.font = UIFont.boldSystemFont(ofSize: 20)
    lblSection.text = model.sectionTitle(for: section)
    return lblSection
  }
  
  override func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int)
    -> CGFloat {
    20
  }
  
  override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let completeAction = UIContextualAction(style: .normal, title: "Done!") {
      [weak self] (action, view, completionHandler) in
      guard let self = self else {
        assertionFailure("Reference to ToDosViewController is nil")
        return
      }
      self.model.markAsComplete(indexPath: indexPath, completionHandler: completionHandler)
    }
    completeAction.backgroundColor = UIColor.systemGreen
    let configuration = UISwipeActionsConfiguration(actions: [completeAction])
    return configuration
  }
}

//MARK: PickerView
extension ToDosViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return model.numberOfComponents
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return model.numberOfSorts
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return model.titleForSortRow(at: row)
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let name = model.titleForSortRow(at: row)
    model.updateSortSelection(to: name)
    alrtSelectSort.textFields?.first?.placeholder = name
  }
}

//MARK: - ToDosViewControllerDelegate
protocol ToDosViewControllerDelegate: AnyObject {
  func toDosViewControllerDidPressAdd(currentList: ToDoItemList)
}
