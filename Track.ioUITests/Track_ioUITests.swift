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
        setupSnapshot(app)
        app.launch()
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testTakeMainListScreenshot() throws {
        snapshot("MainList")
    }
    
    @MainActor
    func testTakeDetailsScreenshot() throws {
        app.buttons["🚀 NASA"].tap()
        snapshot("Details")
    }
    
    @MainActor
    func testTakeAddJobScreenshot() throws {
        // Select job from list on iPad for better interface setup.
        if UIDevice.current.userInterfaceIdiom == .pad {
            app.buttons["🚀 NASA"].tap()
        }
        
        app.buttons["addJob"].tap()
        
        let textField = app.textFields["Enter job name here."]
        textField.tap()
        textField.typeText("DeepSeek")
        snapshot("AddJob")
    }
    
    @MainActor
    func testTakeSankeyScreenshot() throws {
        guard UIDevice.current.userInterfaceIdiom != .pad else {
            // No Visualize button on iPad
            return
        }
        
        app.buttons["Visualize"].tap()
        snapshot("Sankey")
    }
    
    @MainActor
    func testTakeSankeyShareScreenshot() throws {
        // Select job from list on iPad for better interface setup.
        if UIDevice.current.userInterfaceIdiom != .pad {
            app.buttons["🚀 NASA"].tap()
        }
        
        // No visualize button on iPad
        if UIDevice.current.userInterfaceIdiom != .pad {
            app.buttons["Visualize"].tap()
        }
        
        if app.buttons["Share…"].waitForExistence(timeout: 10) {
            app.buttons["Share…"].tap()
        }
        
        snapshot("Share")
    }
}
