//
//  DataManager.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 25/01/2024.
//

import CoreData

class DataManager {
  static let shared = DataManager()
  
  let dataStack: CoreDataStack
  
  init(dataStack: CoreDataStack = CoreDataStack()) {
    self.dataStack = dataStack
  }
  
  func createList(title: String){
    let list = ToDoItemList(context: dataStack.context)
    list.title = title
    list.creationDate = .now
    list.sortOrder = 0
    dataStack.saveContext()
  }
  
  func createToDoItem(taskDescription: String,
                      isComplete: Bool = false,
                      list: ToDoItemList, priority: Int16 = 0) {
    let toDo = ToDoItem(context: dataStack.context)
    try! dataStack.context.obtainPermanentIDs(for: [toDo])
    toDo.creationDate = .now
    toDo.priority = priority
    toDo.taskDescription = taskDescription
    toDo.isComplete = isComplete
    toDo.list = list
    toDo.sortOrder = 0
    dataStack.saveContext()
  }
  
  func delete(_ entity: NSManagedObject){
    dataStack.context.delete(entity)
  }
  
  func saveContext() {
    dataStack.saveContext()
  }
}
