//
//  ToDosFetchTests.swift
//  DoIt2Tests
//
//  Created by Nikita Ivanov on 25/01/2024.
//

import XCTest
@testable import DoIt2

final class ListsFetchTests: XCTestCase {
  let persistenceManager = PersistenceManager(dataStack: TestCoreDataStack())
  let mockViewModel = ListsViewModel()
  var dataSource: ListsViewDataSource!
  var listsFetch: ListsFetch!
  
  override init() {
    mockViewModel.configureDataSource()
    listsFetch = ListsFetch(dataSource: mockViewModel.dataSource!, persistenceManager: persistenceManager)
    super.init()
  }
  
  override func setUpWithError() throws {
    super.setUp()
  }
  
  override func tearDownWithError() throws {
    super.tearDown()
    persistenceManager.dataStack.context.reset()
  }
  
  func test_sort() throws {
    var sortPreference = ListsSortPreference()
    
    //given
    let oldestList = persistenceManager.createList(title: "oldest list")
    let oldList = persistenceManager.createList(title: "old list")
    oldList.creationDate = Date.now.addingTimeInterval(1)
    let newList = persistenceManager.createList(title: "new list")
    newList.creationDate = Date.now.addingTimeInterval(2)
    
    oldList.sortOrder = 0
    oldestList.sortOrder = 1
    newList.sortOrder = 2
  
    //when
    sortPreference.current = .dateNewest
    listsFetch.sort()
    var lists = listsFetch.controller.fetchedObjects!
    
    //then
    XCTAssertEqual(lists,[newList, oldList, oldestList])
    
    //when
    sortPreference.current = .dateOldest
    listsFetch.sort()
    lists = listsFetch.controller.fetchedObjects!
    
    //then
    XCTAssertEqual(lists,[oldestList, oldList, newList])
    
    //when
    sortPreference.current = .custom
    listsFetch.sort()
    lists = listsFetch.controller.fetchedObjects!
    
    //then
    XCTAssertEqual(lists,[oldList, oldestList, newList])
  }
}
