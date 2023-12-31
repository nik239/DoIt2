//
//  ToDosViewModel.swift
//  DoIt
//
//  Created by Nikita Ivanov on 08/06/2023.
//

import UIKit
import CoreData

final class ToDosViewDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> {
  let currentList: ToDoItemList
  
  init(currentList: ToDoItemList, tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<String, NSManagedObjectID>.CellProvider) {
    self.currentList = currentList
    super.init(tableView: tableView, cellProvider: cellProvider)
  }
  
  let currentSort = ToDosSortPreference()
  let dateNewestSort = NSSortDescriptor(key: #keyPath(ToDoItem.creationDate), ascending: false)
  let dateOldestSort = NSSortDescriptor(key: #keyPath(ToDoItem.creationDate), ascending: true)
  let customSort = NSSortDescriptor(key: #keyPath(ToDoItem.sortOrder), ascending: true)
  let completionSort = NSSortDescriptor(key: #keyPath(ToDoItem.isComplete), ascending: true)
  
  private var changeIsUserDriven = false
  
  lazy var fetchedResultsController:
  NSFetchedResultsController<ToDoItem> = {
    makeFetchedResultsController(with: getCurrentFetchRequest())
  }()
  
  private func makeFetchedResultsController(with fetchRequest: NSFetchRequest<ToDoItem>) -> NSFetchedResultsController<ToDoItem> {
    let fetchRequest = getCurrentFetchRequest()
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: PersistenceController.shared.context,
      sectionNameKeyPath: #keyPath(ToDoItem.isComplete),
      cacheName: nil)
    fetchedResultsController.delegate = self
    return fetchedResultsController
  }
  
  private func getCurrentFetchRequest() -> NSFetchRequest<ToDoItem> {
    let fetchRequest = ToDoItem.fetchRequest(list: currentList)
    switch currentSort.current {
    case .dateNewest:
      fetchRequest.sortDescriptors = [completionSort, dateNewestSort]
    case .dateOldest:
      fetchRequest.sortDescriptors = [completionSort, dateOldestSort]
    case .custom:
      fetchRequest.sortDescriptors = [completionSort, customSort, dateNewestSort]
    }
    return fetchRequest
  }
  
  //MARK: TabeView
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return indexPath.section == 0
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    guard destinationIndexPath.section != 1 else {
      
      DispatchQueue.main.async {
        tableView.reloadData()
      }
      
      return
    }
    var toDos = fetchedResultsController.fetchedObjects!
    changeIsUserDriven = true
    let toDo = toDos[sourceIndexPath.row]
    toDos.remove(at: sourceIndexPath.row)
    toDos.insert(toDo, at: destinationIndexPath.row)
    for (index, list) in toDos.enumerated() {
      list.sortOrder = Int16(exactly:index)!
    }
    PersistenceController.shared.saveContext()
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let itemToDelete = fetchedResultsController.object(at: indexPath)
      PersistenceController.shared.context.delete(itemToDelete)
      PersistenceController.shared.saveContext()
    }
  }
}

// MARK: - FetchedResultsControllerDelegate
extension ToDosViewDataSource: NSFetchedResultsControllerDelegate {
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChangeContentWith
                  snapshot: NSDiffableDataSourceSnapshotReference) {
    guard !changeIsUserDriven else {
      changeIsUserDriven = false
      return
    }
    let snapshot = snapshot
    as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
    self.apply(snapshot, animatingDifferences: true)
  }
}
  

