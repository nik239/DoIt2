//
//  Persistence.swift
//  DoIt
//
//  Created by Nikita Ivanov on 14/05/2023.
//

import CoreData

class CoreDataStack {
  
  lazy var context: NSManagedObjectContext = {
    return container.viewContext
  }()
  
  lazy var container: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "DoIt")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  func saveContext(){
    guard context.hasChanges else { return }
    do {
      if !Thread.isMainThread {
        print("Saving on a background Queue!")
      }
      try context.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }
}
