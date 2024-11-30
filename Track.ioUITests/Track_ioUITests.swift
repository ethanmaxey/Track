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
        app.buttons["🔍 Google"].tap()
        snapshot("Details")
    }
    
    @MainActor
    func testTakeAddJobScreenshot() throws {
        app.buttons["Add Job"].tap()
        
        let textField = app.textFields["Enter job name here."]
        textField.tap()
        textField.typeText("NASA")
        snapshot("AddJob")
    }
    
    @MainActor
    func testTakeSankeyScreenshot() throws {
        app.buttons["Visualize"].tap()
        snapshot("Sankey")
    }
    
    @MainActor
    func testTakeSankeyShareScreenshot() throws {
        app.buttons["Visualize"].tap()
        
        if app.buttons["Share…"].waitForExistence(timeout: 10) {
            app.buttons["Share…"].tap()
        }
        
        snapshot("Share")
    }
}
