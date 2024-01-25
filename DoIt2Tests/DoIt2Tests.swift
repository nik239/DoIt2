//
//  DoIt2Tests.swift
//  DoIt2Tests
//
//  Created by Nikita Ivanov on 24/01/2024.
//

import XCTest
@testable import DoIt2

final class NewToDoViewModelTests: XCTestCase {
  var mockList: ToDoItemList!
  var mockModel: NewToDoViewModel!
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    super.setUp()
    mockList = ToDoItemList(context: PersistenceController.shared.context)
    mockModel = NewToDoViewModel(currentList: mockList)
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    PersistenceController.shared.context.delete(mockList)
    try! PersistenceController.shared.context.save()
    mockList = nil
    mockModel = nil
  }
  
  func test_setPriority() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Any test you write for XCTest can be annotated as throws and async.
    // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    //given
    var index = 0
    //when
    mockModel.setPriority(index: index)
    //then
    XCTAssertEqual(mockModel.toDoPriority, Priorities.none.rawValue)
    
    //given
    index = 1
    //when
    mockModel.setPriority(index: index)
    //then
    XCTAssertEqual(mockModel.toDoPriority, Priorities.low.rawValue)
    
    //given
    index = 2
    //when
    mockModel.setPriority(index: index)
    //then
    XCTAssertEqual(mockModel.toDoPriority, Priorities.medium.rawValue)
    
    //given
    index = 3
    //when
    mockModel.setPriority(index: index)
    //then
    XCTAssertEqual(mockModel.toDoPriority, Priorities.high.rawValue)
    
    //given
    index = 100
    //when
    mockModel.setPriority(index: index)
    //then
    XCTAssertEqual(mockModel.toDoPriority, Priorities.none.rawValue)
  }
}
