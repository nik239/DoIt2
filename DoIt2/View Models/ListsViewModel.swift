//
//  ListsViewModel.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 22/01/2024.
//

import UIKit

final class ListsViewModel {
  var dataSource: ListsViewDataSource?
  var tableView: UITableView?
  var persistenceManager: PersistenceManager = PersistenceManager.shared
  
  var sortSelection = ListsSortPreference()
  let numberOfSorts = ListsSorts.allCases.count
  let numberOfComponents = 1
  
  func configureDataSource() {
    guard let tableView = tableView else {
      assertionFailure("ListsViewModel tableView is nil")
      return
    }
    self.dataSource = ListsViewDataSource(tableView: tableView) {
      tableView, indexPath, managedObjectID -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(
        withIdentifier:"\(ListCell.self)",
        for: indexPath)
      guard let listCell = cell as? ListCell else {
        assertionFailure("Couldn't cast cell to ListCell")
        return cell
      }
      guard let list = try?
          self.persistenceManager.dataStack.context.existingObject(with: managedObjectID)
              as? ToDoItemList else {
        assertionFailure("Failed to fetch list")
        return listCell
      }
      listCell.lblTitle.text = list.title
      listCell.lblNumberOfItems.text = "(\(list.toDos.count) items)"
      return listCell
    }
  }
  
  func viewList(at indexPath: IndexPath, with delegate: ListsViewControllerDelegate?) {
    guard let dataSource = dataSource else {
      assertionFailure("ListsViewMOdel dataSource is nil")
      return
    }
    let list = dataSource.listsFetch.controller.object(at: indexPath)
    guard let delegate = delegate else {
      assertionFailure("ListsView delegate is nil")
      return
    }
    delegate.listsViewControllerDidSelectList(list: list)
  }
  
  func titleForSortRow(at index: Int) -> String {
      return ListsSorts.allCases[index].rawValue
  }
  
  func updateSortSelection(to name: String){
    guard let listsSort = ListsSorts(rawValue: name) else {
      assertionFailure("Couldn't init listsSort")
      return
    }
    sortSelection.current = listsSort
  }
}


