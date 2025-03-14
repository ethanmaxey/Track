//
//  Track_ioUITests.swift
//  Track.ioUITests
//
//  Created by Ethan Maxey on 11/28/24.
//

import XCTest

final class Track_ioUITests: XCTestCase {
    var app = XCUIApplication()

    @MainActor
    override func setUp() {
        // UI tests must launch the application that they test.
        app = XCUIApplication()
        app.launchArguments = ["--Reset"]
        setupSnapshot(app)
        app.launch()
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testTakeMainListScreenshot() throws {
        guard UIDevice.current.userInterfaceIdiom != .pad else {
            // No need to see this view on iPad. Details view shows it.
            return
        }

        
        snapshot("MainList")
    }
    
    @MainActor
    func testTakeDetailsScreenshot() throws {
        app.buttons["🚀 NASA"].tap()
        app.swipeUp()
        snapshot("Details")
    }
    
    @MainActor
    func testTakeAddJobScreenshot() throws {
        // Select job from list on iPad for better interface setup.
        if UIDevice.current.userInterfaceIdiom == .pad {
            app.buttons["🚀 NASA"].tap()
        }
        
        app.buttons["addJob"].tap()
        
        let textField = app.textFields["EnterJobNameHere"]
        textField.tap()
        textField.typeText("🎶 TikTok")
        snapshot("AddJob")
    }
    
    @MainActor
    func testTakeSankeyScreenshot() throws {
        guard UIDevice.current.userInterfaceIdiom != .pad else {
            // No Visualize button on iPad
            return
        }
        
        app.buttons["Visualize Tab"].tap()
        snapshot("Sankey")
    }
    
    @MainActor
    func testTakeSankeyShareScreenshot() throws {
        // Select job from list on iPad for better interface setup.
        if UIDevice.current.userInterfaceIdiom == .pad {
            app.buttons["ToggleSidebar"].tap()
        }
        
        // No visualize button on iPad
        if UIDevice.current.userInterfaceIdiom != .pad {
            app.buttons["Visualize Tab"].tap()
        }
        
        if app.buttons["share"].waitForExistence(timeout: 10) {
            app.buttons["share"].tap()
        }
        
        snapshot("Share")
    }
}
