//
//  ListsViewController.swift
//  DoIt
//
//  Created by Nikita Ivanov on 11/06/2023.
//

import UIKit
import CoreData

final class ListsViewController: UITableViewController, UIViewControllerTransitioningDelegate {
  private var dataSource: UITableViewDiffableDataSource<String, NSManagedObjectID>!
  
  lazy var fetchedResultsController:
  NSFetchedResultsController<ToDoItemList> = {
    let fetchRequest = ToDoItemList.fetchRequest()
    let dateSort = NSSortDescriptor(key: #keyPath(ToDoItemList.creationDate), ascending: true)
    fetchRequest.sortDescriptors = [dateSort]
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: PersistenceController.shared.context,
      sectionNameKeyPath: nil,
      cacheName: nil)
    fetchedResultsController.delegate = self
    return fetchedResultsController
  }()

  @objc func addButtonTapped() {
    let newListViewController = NewListViewController()
    newListViewController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
    newListViewController.transitioningDelegate = self
    present(newListViewController, animated: true, completion: nil)
  }
  
  private lazy var addButton: UIBarButtonItem = {
    let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    return btn
  }()
}

//MARK: Life Cycle
extension ListsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItems = [editButtonItem, addButton]
    tableView.register(ListCell.self, forCellReuseIdentifier: "\(ListCell.self)")
    dataSource = configureDataSource()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    UIView.performWithoutAnimation {
      do {
        try fetchedResultsController.performFetch()
      } catch let error as NSError {
        print("Fetching error: \(error), \(error.userInfo)")
      }
    }
  }
}

//MARK: TableView 
extension ListsViewController {
  func configureDataSource() -> UITableViewDiffableDataSource<String, NSManagedObjectID> {
    UITableViewDiffableDataSource(tableView: tableView) {
      tableView, indexPath, managedObjectID -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(
        withIdentifier:"\(ListCell.self)",
        for: indexPath) as! ListCell
      if let list = try?
          PersistenceController.shared.context.existingObject(with: managedObjectID)
          as? ToDoItemList {
        cell.lblDescription.text = list.title
      }
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let list = fetchedResultsController.object(at: indexPath)
    self.navigationController?.pushViewController(ToDosViewController(style: .plain, currentList: list), animated: true)
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let completeAction = UIContextualAction(style: .normal, title: "Delete") {
      [weak self] (action, view, completionHandler) in
      guard let listToDelete = self?.fetchedResultsController.object(at: indexPath) else {
        print("Couldn't get ToDoList from dataSource!")
        return
      }
      PersistenceController.shared.container.viewContext.delete(listToDelete)
      PersistenceController.shared.saveContext()
      completionHandler(true)
    }
    completeAction.backgroundColor = .systemRed
    let configuration = UISwipeActionsConfiguration(actions: [completeAction])
    return configuration
  }
}

// MARK: - FetchedResultsControllerDelegate
extension ListsViewController: NSFetchedResultsControllerDelegate {
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChangeContentWith
                  snapshot: NSDiffableDataSourceSnapshotReference) {
    print("Data changed!")
    let snapshot = snapshot
    as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
    dataSource?.apply(snapshot)
  }
}
