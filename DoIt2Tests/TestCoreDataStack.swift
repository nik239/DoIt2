//
//  TestCoreDataStack.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 25/01/2024.
//

import CoreData
@testable import DoIt2

class TestCoreDataStack: CoreDataStack {
  override init() {
    super.init()
    
    let persistentStoreDescription = NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType
    
    let testContainer = NSPersistentContainer(name: "DoIt")
    testContainer.persistentStoreDescriptions = [persistentStoreDescription]
    
    testContainer.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    
    container = testContainer
  }
}
