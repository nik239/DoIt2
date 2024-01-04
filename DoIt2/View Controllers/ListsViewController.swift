//
//  ListsViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 11/06/2023.
//

import UIKit
import CoreData

// MARK: -ListsViewControllerDelegate
protocol ListsViewControllerDelegate: AnyObject {
  func listsViewControllerDidSelectList(list: ToDoItemList)
  func listsViewControllerDidPressAdd()
}

final class ListsViewController: UITableViewController, UIViewControllerTransitioningDelegate {
  private var dataSource: ListsViewDataSource!
  private var sortSelection = ListsSortPreference()
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
      fld.placeholder = self.sortSelection.current.rawValue
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
      self.dataSource.sort()
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
    setupUI()
    setupTableView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    UIView.performWithoutAnimation {
      do {
        try dataSource.fetchedResultsController.performFetch()
      } catch let error as NSError {
        print("Fetching error: \(error), \(error.userInfo)")
      }
    }
  }
}

//MARK: TableView 
extension ListsViewController {
  func setupTableView() {
    tableView.register(ListCell.self, forCellReuseIdentifier: "\(ListCell.self)")
    dataSource = configureDataSource()
    tableView.delegate = self
  }
  
  func configureDataSource() -> ListsViewDataSource {
    ListsViewDataSource(tableView: tableView) {
      tableView, indexPath, managedObjectID -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(
        withIdentifier:"\(ListCell.self)",
        for: indexPath) as! ListCell
      if let list = try?
          PersistenceController.shared.context.existingObject(with: managedObjectID)
          as? ToDoItemList {
        cell.lblTitle.text = list.title
        cell.lblNumberOfItems.text = "(\(list.toDos.count) items)"
      }
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let list = dataSource.fetchedResultsController.object(at: indexPath)
    delegate!.listsViewControllerDidSelectList(list: list)
  }
}

//MARK: PickerView
extension ListsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return ListsSorts.allCases.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return ListsSorts.allCases[row].rawValue
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let newVal = ListsSorts.allCases[row].rawValue
    sortSelection.current = ListsSorts(rawValue: newVal)!
    self.alrtSelectSort.textFields?.first?.placeholder = newVal
  }
}

