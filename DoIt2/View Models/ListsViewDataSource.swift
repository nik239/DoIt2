//
//  ListsControllerDataSource.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 14/12/2023.
//

import UIKit
import CoreData

final class ListsViewDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> {
  private var changeIsUserDriven = false
  
  let dateNewestSort = NSSortDescriptor(key: #keyPath(ToDoItemList.creationDate), ascending: false)
  let dateOldestSort = NSSortDescriptor(key: #keyPath(ToDoItemList.creationDate), ascending: true)
  let customSort = NSSortDescriptor(key: #keyPath(ToDoItemList.sortOrder), ascending: true)
  
  let currentSort = ListsSortPreference()
  
  lazy var fetchedResultsController:
  NSFetchedResultsController<ToDoItemList> = {
    makeFetchedResultsController(with: getCurrentFetchRequest())
  }()
  
  private func makeFetchedResultsController(with fetchRequest: NSFetchRequest<ToDoItemList>) -> NSFetchedResultsController<ToDoItemList> {
    let fetchRequest = getCurrentFetchRequest()
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: PersistenceController.shared.context,
      sectionNameKeyPath: nil,
      cacheName: nil)
    fetchedResultsController.delegate = self
    return fetchedResultsController
  }
  
  private func getCurrentFetchRequest() -> NSFetchRequest<ToDoItemList> {
    let fetchRequest = ToDoItemList.fetchRequest()
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
  
  func sort() {
    print("Sorting items!")
    print("Sort method: \(currentSort.current.rawValue)")
    let fetchRequest = getCurrentFetchRequest()
    fetchedResultsController = makeFetchedResultsController(with: fetchRequest)
    do {
      try fetchedResultsController.performFetch()
      PersistenceController.shared.saveContext()
    } catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
  }
  
  //MARK: Edditing Data
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    changeIsUserDriven = true
    var lists = fetchedResultsController.fetchedObjects!
    let list = lists[sourceIndexPath.row]
    lists.remove(at: sourceIndexPath.row)
    lists.insert(list, at: destinationIndexPath.row)
    for (index, list) in lists.enumerated() {
      list.sortOrder = Int16(exactly:index)!
    }
    PersistenceController.shared.saveContext()
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
extension ListsViewDataSource: NSFetchedResultsControllerDelegate {
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

// MARK: -Logging
extension ListsViewDataSource {
  func printSnapshot(snapshot: NSDiffableDataSourceSnapshot<String, NSManagedObjectID>) {
    let context = PersistenceController.shared.context
    let itemIdentifiers = snapshot.itemIdentifiers
    for itemIdentifier in itemIdentifiers {
      do {
        if let managedObject = try context.existingObject(with: itemIdentifier) as? ToDoItemList {
          print("Item: \(managedObject.title)")
        }
      } catch {
        print("Error fetching managed object: \(error)")
      }
    }
  }
}
