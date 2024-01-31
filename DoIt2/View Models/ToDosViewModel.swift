//
//  ToDosViewModel.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 22/01/2024.
//

import UIKit

struct ToDosViewModel {
  var dataSource: ToDosViewDataSource?
  var currentList: ToDoItemList
  var tableView: UITableView?
  var persistenceManager: PersistenceManager = PersistenceManager.shared
  
  var sortSelection = ToDosSortPreference()
  let numberOfSorts = ToDosSorts.allCases.count
  let numberOfComponents = 1
  
  mutating func configureDataSource() {
    dataSource = configuredDataSource()
  }
  
  func configuredDataSource() -> ToDosViewDataSource? {
    guard let tableView = tableView else {
      assertionFailure("ToDosViewModel tableView is nil")
      return nil
    }
    let dataSource = ToDosViewDataSource(currentList: currentList, tableView: tableView) {
      tableView, indexPath, managedObjectID -> UITableViewCell? in
      if managedObjectID.isTemporaryID {
        print("temporary ID!")
      }
      if let toDo = try?
          persistenceManager.dataStack.context.existingObject(with: managedObjectID) as? ToDoItem {
        let id = "\(ToDoItemCell.self)" + sectionTitle(isComplete: toDo.isComplete)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        if let toDoCell = cell as? ToDoItemCell {
          toDoCell.lblDescription.text = toDo.taskDescription
          if !toDo.isComplete {
            if let priority = Priorities(rawValue: toDo.priority) {
              toDoCell.imgvPriority.tintColor = Priorities(rawValue: toDo.priority)!.color
            } else {
              assertionFailure("toDo has invalid priority")
            }
          }
          return toDoCell
        } else {
          assertionFailure("Couldn't cast cell to ToDoItemCell")
          return cell
        }
      }
      return nil
    }
    
    return dataSource
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
  
  mutating func updateSortSelection(to name: String){
    guard let currentSelection = ToDosSorts(rawValue: name) else {
      assertionFailure("Couldn't initialize a ToDosSorts object")
      return
    }
    sortSelection.current = currentSelection
  }
}
