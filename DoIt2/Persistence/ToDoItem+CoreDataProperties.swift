//
//  ToDoItem+CoreDataProperties.swift
//  
//
//  Created by Nikita Ivanov on 14/05/2023.
//
//

import Foundation
import CoreData

extension ToDoItem {
  
  @nonobjc public class func fetchRequest(list: ToDoItemList) -> NSFetchRequest<ToDoItem> {
    let request = NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    request.predicate = NSPredicate(format: "list == %@", list)
    return request
  }
  
  @nonobjc public class func activeToDosFetchRequest(list: ToDoItemList) -> NSFetchRequest<ToDoItem> {
    let request = NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    request.predicate = NSPredicate(format: "isComplete == 0")
    request.predicate = NSPredicate(format: "list == %@", list)
    return request
  }
  
  @nonobjc public class func finishedToDosFetchRequest(list: ToDoItemList) -> NSFetchRequest<ToDoItem> {
    let request = NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    request.predicate = NSPredicate(format: "isComplete == 1")
    request.predicate = NSPredicate(format: "list == %@", list)
    return request
  }
  
  @NSManaged public var priority: Int16
  @NSManaged public var creationDate: Date
  @NSManaged public var taskDescription: String
  @NSManaged public var isComplete: Bool
  @NSManaged public var list: ToDoItemList
  @NSManaged public var sortOrder: Int16
  
  static func createWith(taskDescription: String,
                         isComplete: Bool = false,
                         list: ToDoItemList, priority: Int16 = 0) {
    let toDo = ToDoItem(context: PersistenceController.shared.context)
    try! PersistenceController.shared.context.obtainPermanentIDs(for: [toDo])
    toDo.creationDate = .now
    toDo.priority = priority 
    toDo.taskDescription = taskDescription
    toDo.isComplete = isComplete
    toDo.list = list
    toDo.sortOrder = 0
    PersistenceController.shared.saveContext()
  }
}
