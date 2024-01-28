//
//  DataManager.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 25/01/2024.
//

import CoreData

class PersistenceManager {
  static let shared = PersistenceManager()
  
  let dataStack: CoreDataStack
  
  init(dataStack: CoreDataStack = CoreDataStack()) {
    self.dataStack = dataStack
  }
  
  @discardableResult
  func createList(title: String) -> ToDoItemList {
    let list = ToDoItemList(context: dataStack.context)
    list.title = title
    list.creationDate = .now
    list.sortOrder = 0
    dataStack.saveContext()
    return list
  }
  
  @discardableResult
  func createToDoItem(taskDescription: String,
                      isComplete: Bool = false,
                      list: ToDoItemList, priority: Int16 = 0)
                      -> ToDoItem {
    let toDo = ToDoItem(context: dataStack.context)
    try! dataStack.context.obtainPermanentIDs(for: [toDo])
    toDo.creationDate = .now
    toDo.priority = priority
    toDo.taskDescription = taskDescription
    toDo.isComplete = isComplete
    toDo.list = list
    toDo.sortOrder = 0
    dataStack.saveContext()
    return toDo
  }
  
  func delete(_ entity: NSManagedObject){
    dataStack.context.delete(entity)
  }
  
  func saveContext() {
    dataStack.saveContext()
  }
}
