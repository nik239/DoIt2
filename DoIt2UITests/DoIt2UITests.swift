//
//  DoIt2UITests.swift
//  DoIt2UITests
//
//  Created by Nikita Ivanov on 29/01/2024.
//

import XCTest

final class DoIt2UITests: XCTestCase {
  var app: XCUIApplication!
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    app = XCUIApplication()
    app.launch()
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() throws {
    // UI tests must launch the application that they test.
    let myListsNavigationBar = app.navigationBars["My Lists"]
    myListsNavigationBar.buttons["Add"].tap()
    app.staticTexts["To create a new list enter a title and press return.\nTo cancel swipe down."].swipeDown()
    XCTAssert(myListsNavigationBar.staticTexts["My Lists"].exists)
        
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}