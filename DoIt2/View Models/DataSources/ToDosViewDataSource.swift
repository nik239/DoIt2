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
  lazy var toDosFetch = ToDosFetch(dataSource: self, currentList: currentList)
  
  //flag to prevent redundant/erroneous view updates
  private var changeIsUserDriven = false
  
  init(currentList: ToDoItemList, tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<String, NSManagedObjectID>.CellProvider) {
    self.currentList = currentList
    super.init(tableView: tableView, cellProvider: cellProvider)
  }
  
  func loadData() {
    do {
      try toDosFetch.controller.performFetch()
    } catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
  }
  
  //MARK: - TableView Edditing
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return indexPath.section == 0
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    //no completing an item by dragging it!
    guard destinationIndexPath.section != 1 else {
      DispatchQueue.main.async {
        tableView.reloadData()
      }
      return
    }
    changeIsUserDriven = true
    var toDos = toDosFetch.controller.fetchedObjects!
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
      let itemToDelete = toDosFetch.controller.object(at: indexPath)
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
  

