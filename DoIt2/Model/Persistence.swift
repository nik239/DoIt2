//
//  Persistence.swift
//  DoIt
//
//  Created by Nikita Ivanov on 14/05/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    
    static func safeContextSave(){
        do {
            try shared.container.viewContext.save()
        } catch {
            print("Failed to save context!")
        }
    }

    init() {
        container = NSPersistentContainer(name: "DoIt")
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
      
    //multithreading specifications wtf?
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.name = "viewContext"
    container.viewContext.mergePolicy =
    NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.undoManager = nil
    container.viewContext.shouldDeleteInaccessibleFaults = true
  }
}
