//
//  ListsViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 11/06/2023.
//

import UIKit
import CoreData

final class ListsViewController: UITableViewController, UIViewControllerTransitioningDelegate {
  lazy var model = ListsViewModel()
  weak var delegate: ListsViewControllerDelegate?
  
  //MARK: UI
  private func setupUI() {
    navigationItem.rightBarButtonItems = [editButtonItem, btnNewList]
    navigationItem.leftBarButtonItem = btnSort
    self.navigationItem.title = "My Lists"
  }
  
  private lazy var pkrSort: UIPickerView = {
    let pkr = UIPickerView()
    pkr.dataSource = self
    pkr.delegate = self
    return pkr
  }()
  
  private lazy var btnSort: UIBarButtonItem = {
    let btn = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(presentSortSelector))
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
      self.model.dataSource!.listsFetch.sort()
    }
    alrt.addAction(sortAction)
    alrt.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    return alrt
  }()
  
  private lazy var btnNewList: UIBarButtonItem = {
    let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewList))
    return btn
  }()
  
  @objc func createNewList() {
    delegate!.listsViewControllerDidPressAdd()
  }
}

//MARK: Life Cycle
extension ListsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    model.tableView = tableView
    setupUI()
    setupTableView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    UIView.performWithoutAnimation {
      model.dataSource!.loadData()
    }
  }
}

//MARK: TableView 
extension ListsViewController {
  func setupTableView() {
    tableView.register(ListCell.self, forCellReuseIdentifier: "\(ListCell.self)")
    tableView.delegate = self
    model.configureDataSource()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let list = model.dataSource?.listsFetch.controller.object(at: indexPath)
    delegate!.listsViewControllerDidSelectList(list: list!)
  }
}

//MARK: PickerView
extension ListsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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

// MARK: -ListsViewControllerDelegate
protocol ListsViewControllerDelegate: AnyObject {
  func listsViewControllerDidSelectList(list: ToDoItemList)
  func listsViewControllerDidPressAdd()
}
