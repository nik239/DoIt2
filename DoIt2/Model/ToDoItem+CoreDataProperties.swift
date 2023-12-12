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
  
  @NSManaged public var taskDescription: String
  @NSManaged public var isComplete: Bool
  @NSManaged public var list: ToDoItemList
  
  static func createWith(taskDescription: String, isComplete: Bool = false, list: ToDoItemList) {
    let ToDo = ToDoItem(context: PersistenceController.shared.container.viewContext)
    ToDo.taskDescription = taskDescription
    ToDo.isComplete = isComplete
    ToDo.list = list
    do {
      try PersistenceController.shared.container.viewContext.save()
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
