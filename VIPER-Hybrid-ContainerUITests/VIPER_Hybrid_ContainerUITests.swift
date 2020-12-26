//
//  VIPER_Hybrid_ContainerUITests.swift
//  VIPER-Hybrid-ContainerUITests
//
//  Created by Demitri Delinikolas on 26/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import XCTest

class VIPER_Hybrid_ContainerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {

        //Launch the app
        let app = XCUIApplication()
        app.launch()
        
        //wait (max 5 secs) for the Intro screen to appear - check the NavigationBar Title
        let introText = app.navigationBars["Intro"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: introText, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        //Tap the first (to the top) button to see The React Apps
        let element = app.otherElements.containing(.navigationBar, identifier:"Intro").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        
        element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()

        //wait (max 5 secs) for the React Applications screen to appear - check the NavigationBar Title
        let reactText = app.navigationBars["React Applications"]
        expectation(for: exists, evaluatedWith: reactText, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        //check the back button exists
        XCTAssert(app.navigationBars["React Applications"].buttons["Intro"].exists)

        //tap the back button
        app.navigationBars["React Applications"].buttons["Intro"].tap()

        //wait (max 5 secs) for the app to move to the intro screen
        expectation(for: exists, evaluatedWith: introText, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        //move to playbook now by tapping the second button
        XCUIApplication().otherElements.containing(.navigationBar, identifier:"Intro").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .button).element.tap()

        //wait for the screen to appear (max 5 seconds)
        let playBookText = app.navigationBars["Playbook"]
        expectation(for: exists, evaluatedWith: playBookText, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        //check for the correct title
        XCTAssert(app.navigationBars["Playbook"].buttons["Intro"].exists)
        
        //move vack
        app.navigationBars["Playbook"].buttons["Intro"].tap()
        
        //Expect to arrive at the intro screen (max 5 secs)
        expectation(for: exists, evaluatedWith: introText, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

    }
    
}
