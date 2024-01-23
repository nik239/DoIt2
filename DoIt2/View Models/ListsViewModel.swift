//
//  ListsViewModel.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 22/01/2024.
//

import UIKit

struct ListsViewModel {
  var dataSource: ListsViewDataSource?
  var tableView: UITableView?
  weak var delegate: ListsViewControllerDelegate?
  
  var sortSelection = ListsSortPreference()
  let numberOfSorts = ListsSorts.allCases.count
  let numberOfComponents = 1
  
  mutating func configureDataSource() {
    dataSource =
    ListsViewDataSource(tableView: tableView!) {
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
  
  func presentNewListView() {
    delegate!.listsViewControllerDidPressAdd()
  }
  
  func viewList(at indexPath: IndexPath) {
    let list = dataSource!.listsFetch.controller.object(at: indexPath)
    delegate!.listsViewControllerDidSelectList(list: list)
  }
  
  func titleForSortRow(at index: Int) -> String {
      return ListsSorts.allCases[index].rawValue
  }
  
  mutating func updateSortSelection(to name: String){
    sortSelection.current = ListsSorts(rawValue: name)!
  }
}


