//
//  FastingTrackerUITests.swift
//  FastingTrackerUITests
//
//  Created by ChrisSlater-Jones on 06/03/2026.
//

import XCTest

final class FastingTrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        // Test that the main tab view loads
        XCTAssertTrue(app.tabBars.firstMatch.exists, "Tab bar should exist")
        
        // Test that all tabs are present
        let homeTab = app.tabBars.buttons["Home"]
        let friendsTab = app.tabBars.buttons["Friends"]
        let notificationsTab = app.tabBars.buttons["Notifications"]
        let learnTab = app.tabBars.buttons["Learn"]
        let profileTab = app.tabBars.buttons["Profile"]
        
        XCTAssertTrue(homeTab.exists, "Home tab should exist")
        XCTAssertTrue(friendsTab.exists, "Friends tab should exist")
        XCTAssertTrue(notificationsTab.exists, "Notifications tab should exist")
        XCTAssertTrue(learnTab.exists, "Learn tab should exist")
        XCTAssertTrue(profileTab.exists, "Profile tab should exist")
    }
    
    @MainActor
    func testNavigationBetweenTabs() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Test tapping between tabs
        let friendsTab = app.tabBars.buttons["Friends"]
        friendsTab.tap()
        // Small delay to allow navigation
        Thread.sleep(forTimeInterval: 0.5)
        
        let learnTab = app.tabBars.buttons["Learn"]
        learnTab.tap()
        Thread.sleep(forTimeInterval: 0.5)
        
        let homeTab = app.tabBars.buttons["Home"]
        homeTab.tap()
        Thread.sleep(forTimeInterval: 0.5)
        
        // Should successfully navigate without crashes
        XCTAssertTrue(app.tabBars.firstMatch.exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
