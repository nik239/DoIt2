//
//  DoIt2UITests.swift
//  DoIt2UITests
//
//  Created by Nikita Ivanov on 29/01/2024.
//

import XCTest

final class DoIt2UITests: XCTestCase {
  var app: XCUIApplication!
  var myGestures: CustomGestures!
  
  override func setUpWithError() throws {
    super.setUp()
    app = XCUIApplication()
    myGestures = CustomGestures(app: app)
    app.launch()
    continueAfterFailure = false
    
  }
  
  override func tearDownWithError() throws {
    app = nil
    super.tearDown()
  }
  
  func test_newListPageSheetPresentation() throws {
    // UI tests must launch the application that they test.
    
    //given
    app.navigationBars["My Lists"].buttons["Add"].tap()
    
    //when
    let newListVCBackground = app.otherElements["NewListViewControllerBackground"]
    
    //then
    XCTAssert(newListVCBackground.exists)
    
    //when
    myGestures.swipeDownWide()
    
    //then
    XCTAssertFalse(newListVCBackground.exists)
    
  }
  
  func test_ListsTableViewTitle() throws {
    let myListsNavigationBar = app.navigationBars["My Lists"]
    XCTAssert(myListsNavigationBar.staticTexts["My Lists"].exists)
  }
  
  func test_ToDosTableViewTitle() throws {
    
    let app = XCUIApplication()
    app.tables/*@START_MENU_TOKEN@*/.staticTexts["Ma Homies "]/*[[".cells.staticTexts[\"Ma Homies \"]",".staticTexts[\"Ma Homies \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    app.navigationBars["Ma Homies"].staticTexts["Ma Homies"].tap()
                
  }
    
    

  
//  // takes a while to run
//  func testLaunchPerformance() throws {
//    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//      // This measures how long it takes to launch your application.
//      measure(metrics: [XCTApplicationLaunchMetric()]) {
//        XCUIApplication().launch()
//      }
//    }
//  }
}
