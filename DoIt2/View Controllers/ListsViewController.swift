//
//  ListsViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 11/06/2023.
//

import UIKit
import CoreData

final class ListsViewController: UITableViewController, UIViewControllerTransitioningDelegate {
  private var dataSource: UITableViewDiffableDataSource<Section, ToDoItemList>!

  private lazy var addButton: UIBarButtonItem = {
    let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    return btn
  }()
  
  @objc func addButtonTapped() {
    let newListViewController = NewListViewController(update: updateDataSource)
    newListViewController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
    newListViewController.transitioningDelegate = self
    present(newListViewController, animated: true, completion: nil)
  }
}

//MARK: Lifecycle methods
extension ListsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItems = [editButtonItem, addButton]
    tableView.register(ListCell.self, forCellReuseIdentifier: "\(ListCell.self)")
    configureDataSource()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    updateDataSource()
  }
}

//MARK: TableView methods
extension ListsViewController {
  func configureDataSource() {
    dataSource = UITableViewDiffableDataSource(tableView: tableView) {
      tableView, indexPath, toDoList -> UITableViewCell? in
      guard let cell = tableView.dequeueReusableCell(withIdentifier:"\(ListCell.self)", for: indexPath) as? ListCell
      else { fatalError("Could not create ListCell") }
      cell.lblDescription.text = toDoList.title
      return cell
    }
  }
  
  func updateDataSource() {
    var newSnapshot = NSDiffableDataSourceSnapshot<Section, ToDoItemList>()
    newSnapshot.appendSections(Section.allCases)
    let request = ToDoItemList.fetchRequest()
    let results = try! PersistenceController.shared.container.viewContext.fetch(request)
    newSnapshot.appendItems(results, toSection: .active)
    dataSource.apply(newSnapshot, animatingDifferences: true)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let toDoList = dataSource.itemIdentifier(for: indexPath) else {
      print("Could not find the underlieing ToDoList!")
      return
    }
    self.navigationController?.pushViewController(ToDosViewController(style: .plain, currentList: toDoList), animated: true)
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
      super.setEditing(editing, animated: true)
      tableView.setEditing(editing, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
    print("firing EditingStyle!")
    if editingStyle == .delete {
      print("firing delete!")
      let request = ToDoItemList.fetchRequest()
      do {
        let results = try PersistenceController.shared.container.viewContext.fetch(request)
        print(results)
        let objectToDelete = results[indexPath.row] as ToDoItemList
        PersistenceController.shared.container.viewContext.delete(objectToDelete)
        PersistenceController.safeContextSave()
        updateDataSource()
      } catch {
        print("Failed to fetch ToDoItemList!")
      }
    }
  }
}
