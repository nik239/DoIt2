//
//  CustomGestures.swift
//  DoIt2UITests
//
//  Created by Nikita Ivanov on 31/01/2024.
//

import XCTest

//the .swipeDown() method lacks the amplitude to dismiss a .pageSheet modal view
struct CustomGestures {
  let app: XCUIApplication
  
  func swipeDownWide() {
    let startPoint = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
    let endPoint = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.7))
    startPoint.press(forDuration: 0.1, thenDragTo: endPoint)
  }
}
