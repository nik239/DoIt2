//
//  ToDosViewModel.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 22/01/2024.
//

import UIKit

final class ToDosViewModel {
  var currentList: ToDoItemList
  
  var dataSource: ToDosViewDataSource?
  var tableView: UITableView?
  var persistenceManager: PersistenceManager
  
  var sortSelection = ToDosSortPreference()
  let numberOfSorts = ToDosSorts.allCases.count
  let numberOfComponents = 1
  
  init(currentList: ToDoItemList, persistenceManager: PersistenceManager = PersistenceManager.shared){
    self.currentList = currentList
    self.persistenceManager = persistenceManager
  }
  
  func configureDataSource() {
    guard let tableView = tableView else {
      assertionFailure("ToDosViewModel tableView is nil")
      return
    }
    self.dataSource = ToDosViewDataSource(currentList: currentList, tableView: tableView) {
      tableView, indexPath, managedObjectID -> UITableViewCell? in
      guard let toDo = try?
              self.persistenceManager.dataStack.context.existingObject(with: managedObjectID)
              as? ToDoItem else {
        assertionFailure("Failed to fetch the toDo")
        return nil
      }
      let id = "\(ToDoItemCell.self)" + self.sectionTitle(isComplete: toDo.isComplete)
      let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
      guard let toDoCell = cell as? ToDoItemCell else {
        assertionFailure("Couldn't cast cell to ToDoItemCell")
        return cell
      }
      toDoCell.lblDescription.text = toDo.taskDescription
      if !toDo.isComplete {
        if let priority = Priorities(rawValue: toDo.priority) {
          toDoCell.imgvPriority.tintColor = Priorities(rawValue: toDo.priority)!.color
        } else {
          assertionFailure("toDo has invalid priority")
        }
      }
      return toDoCell
    }
  }
  
  func sectionTitle(for section: Int) -> String {
    return sectionTitle(isComplete: (section == 1))
  }
  
  func sectionTitle(isComplete: Bool) -> String {
    return isComplete ? Sections.finished.rawValue : Sections.todo.rawValue
  }
  
  func markAsComplete(indexPath: IndexPath, completionHandler: (Bool) -> Void){
    guard let dataSource = dataSource else {
      assertionFailure("ToDos Data source nil")
      return
    }
    let toDo = dataSource.toDosFetch.controller.object(at: indexPath)
    if toDo.isComplete {
      completionHandler(false)
      return
    }
    toDo.isComplete = true
    completionHandler(true)
  }
  
  func titleForSortRow(at index: Int) -> String {
    return ToDosSorts.allCases[index].rawValue
  }
  
  func updateSortSelection(to name: String){
    guard let currentSelection = ToDosSorts(rawValue: name) else {
      assertionFailure("Couldn't initialize a ToDosSorts object")
      return
    }
    sortSelection.current = currentSelection
  }
}
