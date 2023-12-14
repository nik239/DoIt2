//
//  ToDosViewModel.swift
//  DoIt
//
//  Created by Nikita Ivanov on 08/06/2023.
//

import UIKit
import CoreData

final class TaskListDataSource: UITableViewDiffableDataSource<ToDoSection, ToDoItem> {
  let currentList: ToDoItemList
  init(currentList: ToDoItemList, tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<ToDoSection, ToDoItem>.CellProvider) {
    self.currentList = currentList
    super.init(tableView: tableView, cellProvider: cellProvider)
  }
  
  func update() {
    var newSnapshot = NSDiffableDataSourceSnapshot<ToDoSection, ToDoItem>()
    newSnapshot.appendSections(ToDoSection.allCases)
    let request = ToDoItem.fetchRequest(list: currentList)
    let results = try! PersistenceController.shared.container.viewContext.fetch(request)
    for item in results {
      newSnapshot.appendItems([item], toSection: item.isComplete ? .finished : .active)
    }
    self.apply(newSnapshot, animatingDifferences: true)
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "Active" : "Finished"
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
    if editingStyle == .delete {
      guard let itemToDelete = self.itemIdentifier(for: indexPath) else {
        print("Couldn't get toDoItem from dataSource!")
        return
      }
      PersistenceController.shared.container.viewContext.delete(itemToDelete)
      PersistenceController.shared.saveContext()
      update()
    }
  }
  
  //    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
  //        guard sourceIndexPath.section == destinationIndexPath.section,
  //              let toDoToMove = itemIdentifier(for: sourceIndexPath),
  //              let toDoAtDestination = itemIdentifier(for: destinationIndexPath) else {
  //            return }
  //    update()
  //    }
}

