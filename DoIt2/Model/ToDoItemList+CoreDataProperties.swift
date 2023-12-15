//
//  ToDoItemList+CoreDataProperties.swift
//  DoIt
//
//  Created by Nikita Ivanov on 10/06/2023.
//
//

import Foundation
import CoreData

extension ToDoItemList {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItemList> {
    return NSFetchRequest<ToDoItemList>(entityName: "ToDoItemList")
  }
  
  @NSManaged public var title: String?
  @NSManaged public var toDos: [ToDoItem]
  @NSManaged public var creationDate: Date
  @NSManaged public var customSort: Int16
  
  static func createWith(title: String) {
    let list = ToDoItemList(context: PersistenceController.shared.context)
    list.title = title
    list.creationDate = .now
    list.customSort = 0
    PersistenceController.shared.saveContext()
  }
}

// MARK: Generated accessors for toDos
extension ToDoItemList {
  
  @objc(insertObject:inToDosAtIndex:)
  @NSManaged public func insertIntoToDos(_ value: ToDoItem, at idx: Int)
  
  @objc(removeObjectFromToDosAtIndex:)
  @NSManaged public func removeFromToDos(at idx: Int)
  
  @objc(insertToDos:atIndexes:)
  @NSManaged public func insertIntoToDos(_ values: [ToDoItem], at indexes: NSIndexSet)
  
  @objc(removeToDosAtIndexes:)
  @NSManaged public func removeFromToDos(at indexes: NSIndexSet)
  
  @objc(replaceObjectInToDosAtIndex:withObject:)
  @NSManaged public func replaceToDos(at idx: Int, with value: ToDoItem)
  
  @objc(replaceToDosAtIndexes:withToDos:)
  @NSManaged public func replaceToDos(at indexes: NSIndexSet, with values: [ToDoItem])
  
  @objc(addToDosObject:)
  @NSManaged public func addToToDos(_ value: ToDoItem)
  
  @objc(removeToDosObject:)
  @NSManaged public func removeFromToDos(_ value: ToDoItem)
  
  @objc(addToDos:)
  @NSManaged public func addToToDos(_ values: NSOrderedSet)
  
  @objc(removeToDos:)
  @NSManaged public func removeFromToDos(_ values: NSOrderedSet)
  
}

extension ToDoItemList : Identifiable {
  
}
