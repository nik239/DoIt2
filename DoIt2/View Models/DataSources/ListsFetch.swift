//
//  ListsFetch.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 23/01/2024.
//

import CoreData

struct ListsFetch {
  let dataSource: ListsViewDataSource
  var persistenceManager: PersistenceManager = PersistenceManager.shared
  
  let dateNewestSort = NSSortDescriptor(key: #keyPath(ToDoItemList.creationDate), ascending: false)
  let dateOldestSort = NSSortDescriptor(key: #keyPath(ToDoItemList.creationDate), ascending: true)
  let customSort = NSSortDescriptor(key: #keyPath(ToDoItemList.sortOrder), ascending: true)
  
  let currentSort = ListsSortPreference()
  
  lazy var controller:
  NSFetchedResultsController<ToDoItemList> = {
    makeFetchedResultsController(with: getCurrentFetchRequest())
  }()
  
  private func makeFetchedResultsController(with fetchRequest: NSFetchRequest<ToDoItemList>) -> NSFetchedResultsController<ToDoItemList> {
    let fetchRequest = getCurrentFetchRequest()
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: persistenceManager.dataStack.context,
      sectionNameKeyPath: nil,
      cacheName: nil)
    fetchedResultsController.delegate = dataSource
    return fetchedResultsController
  }
  
  private func getCurrentFetchRequest() -> NSFetchRequest<ToDoItemList> {
    let fetchRequest = ToDoItemList.fetchRequest()
    switch currentSort.current {
    case .dateNewest:
      fetchRequest.sortDescriptors = [dateNewestSort]
    case .dateOldest:
      fetchRequest.sortDescriptors = [dateOldestSort]
    case .custom:
      fetchRequest.sortDescriptors = [customSort, dateNewestSort]
    }
    return fetchRequest
  }
  
  mutating func sort() {
    print("Sorting items!")
    print("Sort method: \(currentSort.current.rawValue)")
    let fetchRequest = getCurrentFetchRequest()
    controller = makeFetchedResultsController(with: fetchRequest)
    do {
      try controller.performFetch()
    } catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
  }
}
