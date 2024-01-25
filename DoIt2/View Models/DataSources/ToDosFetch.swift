//
//  ToDosResultsController.swift
//  DoIt2
//
//  Created by Nikita Ivanov on 22/01/2024.
//

import CoreData

struct ToDosFetch {
  let dataSource: ToDosViewDataSource
  
  let currentList: ToDoItemList
  
  let dateNewestSort = NSSortDescriptor(key: #keyPath(ToDoItem.creationDate), ascending: false)
  let dateOldestSort = NSSortDescriptor(key: #keyPath(ToDoItem.creationDate), ascending: true)
  let priorityHighestSort = NSSortDescriptor(key: #keyPath(ToDoItem.priority), ascending: false)
  let priorityLowestSort = NSSortDescriptor(key: #keyPath(ToDoItem.priority), ascending: true)
  let customSort = NSSortDescriptor(key: #keyPath(ToDoItem.sortOrder), ascending: true)
  let completionSort = NSSortDescriptor(key: #keyPath(ToDoItem.isComplete), ascending: true)
  
  let currentSort = ToDosSortPreference()
  
  lazy var controller:
  NSFetchedResultsController<ToDoItem> = {
    makeFetchedResultsController(with: getCurrentFetchRequest())
  }()
  
  private func makeFetchedResultsController(with fetchRequest: NSFetchRequest<ToDoItem>) -> NSFetchedResultsController<ToDoItem> {
    let fetchRequest = getCurrentFetchRequest()
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: PersistenceController.shared.context,
      sectionNameKeyPath: #keyPath(ToDoItem.isComplete),
      cacheName: nil)
    fetchedResultsController.delegate = dataSource
    return fetchedResultsController
  }
  
  private func getCurrentFetchRequest() -> NSFetchRequest<ToDoItem> {
    let fetchRequest = ToDoItem.fetchRequest(list: currentList)
    switch currentSort.current {
    case .dateNewest:
      fetchRequest.sortDescriptors = [completionSort, dateNewestSort]
    case .dateOldest:
      fetchRequest.sortDescriptors = [completionSort, dateOldestSort]
    case .priorityHighest:
      fetchRequest.sortDescriptors = [completionSort, priorityHighestSort]
    case .priorityLowest:
      fetchRequest.sortDescriptors = [completionSort, priorityLowestSort]
    case .custom:
      fetchRequest.sortDescriptors = [completionSort, customSort, dateNewestSort]
    }
    return fetchRequest
  }
  
  mutating func sort() {
    let fetchRequest = getCurrentFetchRequest()
    controller = makeFetchedResultsController(with: fetchRequest)
    do {
      try controller.performFetch()
      //PersistenceController.shared.saveContext()
    } catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
  }
}
