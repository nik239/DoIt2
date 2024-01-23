//
//  ListsControllerDataSource.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 14/12/2023.
//

import UIKit
import CoreData

final class ListsViewDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> {
  lazy var listsFetch = ListsFetch(dataSource: self)
  
  //flag that prevents redundant/erroneous view updates
  private var changeIsUserDriven = false
  
  func loadData(){
    do {
      try listsFetch.controller.performFetch()
    } catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
  }
  
  //MARK: TableView Editing
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    changeIsUserDriven = true
    var lists = listsFetch.controller.fetchedObjects!
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
      let listToDelete = listsFetch.controller.object(at: indexPath)
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
