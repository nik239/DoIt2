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
  weak var delegate: ToDosViewControllerDelegate?
  
  var sortSelection = ToDosSortPreference()
  let numberOfSorts = ToDosSorts.allCases.count
  let numberOfComponents = 1
  
  mutating func configureDataSource() {
    dataSource = configuredDataSource()
  }
  
  func configuredDataSource() -> ToDosViewDataSource {
    ToDosViewDataSource(currentList: currentList, tableView: tableView!) {
      tableView, indexPath, managedObjectID -> UITableViewCell? in
      if managedObjectID.isTemporaryID {
        print("temporary ID!")
      }
      if let toDo = try?
          PersistenceController.shared.context.existingObject(with: managedObjectID) as? ToDoItem {
        let id = "\(ToDoItemCell.self)" + sectionTitle(isComplete: toDo.isComplete)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ToDoItemCell
        cell.lblDescription.text = toDo.taskDescription
        if !toDo.isComplete {
          cell.imgvPriority.tintColor = Priorities(rawValue: toDo.priority)!.color
        }
        return cell
      }
      return nil
    }
  }
  
  func presentNewToDoView(){
    delegate!.toDosViewControllerDidPressAdd(currentList: currentList)
  }
  
  func sectionTitle(for section: Int) -> String {
    return sectionTitle(isComplete: (section == 1))
  }
  
  func sectionTitle(isComplete: Bool) -> String {
    return isComplete ? Sections.finished.rawValue : Sections.todo.rawValue
  }
  
  func markAsComplete(indexPath: IndexPath, completionHandler: (Bool) -> Void){
    let toDo = dataSource!.toDosFetch.controller.object(at: indexPath)
    if toDo.isComplete {
      completionHandler(false)
      return
    }
    toDo.isComplete = true
    PersistenceController.shared.saveContext()
    completionHandler(true)
  }
  
  func titleForSortRow(at index: Int) -> String {
    return ToDosSorts.allCases[index].rawValue
  }
  
  mutating func updateSortSelection(to name: String){
    sortSelection.current = ToDosSorts(rawValue: name)!
  }
}
