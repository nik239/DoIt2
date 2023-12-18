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
  let currentSort = ToDosSortPreference()
  
  init(currentList: ToDoItemList, tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<String, NSManagedObjectID>.CellProvider) {
    self.currentList = currentList
    super.init(tableView: tableView, cellProvider: cellProvider)
  }
  
  private var changeIsUserDriven = false
  
  let dateNewestSort = NSSortDescriptor(key: #keyPath(ToDoItem.creationDate), ascending: false)
  let dateOldestSort = NSSortDescriptor(key: #keyPath(ToDoItem.creationDate), ascending: true)
  let customSort = NSSortDescriptor(key: #keyPath(ToDoItem.sortOrder), ascending: true)
  
  
  
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
      fetchRequest.sortDescriptors = [dateNewestSort]
    case .dateOldest:
      fetchRequest.sortDescriptors = [dateOldestSort]
    case .custom:
      fetchRequest.sortDescriptors = [customSort, dateNewestSort]
    }
    return fetchRequest
  }
  
  //MARK: Edditing Data
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let listToDelete = fetchedResultsController.object(at: indexPath)
      PersistenceController.shared.context.delete(listToDelete)
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
  
  
  
  
  
  
  

//  
//  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    return section == 0 ? "Active" : "Finished"
//  }
//  
//  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
//    if editingStyle == .delete {
//      guard let itemToDelete = self.itemIdentifier(for: indexPath) else {
//        print("Couldn't get toDoItem from dataSource!")
//        return
//      }
//      PersistenceController.shared.container.viewContext.delete(itemToDelete)
//      PersistenceController.shared.saveContext()
//      update()
//    }
//  }
//  
//
//  
//  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//    return true
//  }


