//
//  Track_ioUITests.swift
//  Track.ioUITests
//
//  Created by Ethan Maxey on 11/28/24.
//

import XCTest

final class Track_ioUITests: XCTestCase {
    @discardableResult
    private func waitAndTap(_ element: XCUIElement, timeout: TimeInterval = 10, file: StaticString = #filePath, line: UInt = #line) -> Bool {
        let existed = element.waitForExistence(timeout: timeout)
        if !existed {
            attachDebugInfo(name: "waitAndTap missing element")
        }
        XCTAssertTrue(existed, "Expected element to exist before tapping: \(element)", file: file, line: line)
        if existed {
            element.tap()
        }
        return existed
    }

    private func assertExists(_ element: XCUIElement, timeout: TimeInterval = 10, message: String, file: StaticString = #filePath, line: UInt = #line) {
        let existed = element.waitForExistence(timeout: timeout)
        if !existed {
            attachDebugInfo(name: "assertExists missing element")
        }
        XCTAssertTrue(existed, message, file: file, line: line)
    }
    
    private func attachDebugInfo(name: String = "UI Debug", includeScreenshot: Bool = true) {
        let hierarchy = app.debugDescription
        let data = hierarchy.data(using: .utf8) ?? Data()
        let attachment = XCTAttachment(data: data)
        attachment.name = name + " Hierarchy"
        attachment.lifetime = .keepAlways
        add(attachment)
        if includeScreenshot {
            let screenshot = XCUIScreen.main.screenshot()
            let imageAttachment = XCTAttachment(screenshot: screenshot)
            imageAttachment.name = name + " Screenshot"
            imageAttachment.lifetime = .keepAlways
            add(imageAttachment)
        }
    }
    
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

        XCTAssertTrue(app.buttons["🚀 NASA"].waitForExistence(timeout: 10) || app.buttons["🍏 Apple"].waitForExistence(timeout: 1), "Expected at least one job to be visible before taking MainList screenshot")
        
        snapshot("MainList")
    }
    
    @MainActor
    func testTakeDetailsScreenshot() throws {
        waitAndTap(app.buttons["🚀 NASA"])
        app.swipeUp()
        // Wait for a details container: scroll view or any static text that is unique to details
        let detailsScroll = app.scrollViews.firstMatch
        let detailsText = app.staticTexts["Details"]
        let existed = detailsScroll.waitForExistence(timeout: 5) || detailsText.waitForExistence(timeout: 5)
        if !existed { attachDebugInfo(name: "Details container not found") }
        XCTAssertTrue(existed, "Expected a details container (scroll view or 'Details' label) to exist before snapshot")
        snapshot("Details")
    }
    
    @MainActor
    func testTakeAddJobScreenshot() throws {
        // Select job from list on iPad for better interface setup.
        if UIDevice.current.userInterfaceIdiom == .pad {
            app.buttons["🚀 NASA"].tap()
        }
        
        // Try primary add button, otherwise try a navigation bar add button
        if !waitAndTap(app.buttons["addJob"]) {
            let navAdd = app.navigationBars.buttons["addJob"].firstMatch
            if navAdd.exists == false {
                // Fallback: try a generic Add button in the navigation bar
                let genericAdd = app.navigationBars.buttons.matching(NSPredicate(format: "label == %@ || identifier == %@", "Add", "Add")).firstMatch
                if genericAdd.exists { genericAdd.tap() }
            } else {
                navAdd.tap()
            }
        }
        
        // Allow presentation animations to settle
        _ = app.wait(for: .runningForeground, timeout: 0.5)
        
        // Look for a text field across potential containers on iPhone/iPad (sheet, popover, alert, or inline)
        let nameId = "EnterJobNameHere"
        var nameField: XCUIElement?

        // 1) Prefer explicit identifier anywhere
        let direct = app.textFields[nameId]
        if direct.waitForExistence(timeout: 2) { nameField = direct }

        // 2) Probe common containers for the field
        if nameField == nil {
            for container in [app.sheets, app.popovers, app.alerts] {
                let candidate = container.textFields[nameId].firstMatch
                if candidate.exists { nameField = candidate; break }
                let anyTF = container.textFields.firstMatch
                if anyTF.exists { nameField = anyTF; break }
            }
        }

        // 3) Try placeholder-based search across the whole app
        if nameField == nil {
            let placeholders = [
                NSPredicate(format: "placeholderValue == %@", "Enter job name"),
                NSPredicate(format: "placeholderValue CONTAINS[c] %@", "job"),
                NSPredicate(format: "placeholderValue CONTAINS[c] %@", "name")
            ]
            for p in placeholders {
                let q = app.textFields.matching(p)
                let c = q.firstMatch
                if c.exists { nameField = c; break }
            }
        }

        // 4) As a last resort, take the first visible text field anywhere
        if nameField == nil {
            let anyTF = app.textFields.element(boundBy: 0)
            if anyTF.exists { nameField = anyTF }
        }

        // Final assertion with better diagnostics
        if nameField == nil || nameField!.exists == false {
            attachDebugInfo(name: "Add Job text field not found")
            XCTFail("Could not find a text field for job name after tapping Add. Visible text fields count: \(app.textFields.count)")
            return
        }

        if let field = nameField {
            waitAndTap(field)
            field.typeText("🎶 TikTok")
        }
        
        snapshot("AddJob")
    }
    
    @MainActor
    func testTakeSankeyScreenshot() throws {
        guard UIDevice.current.userInterfaceIdiom != .pad else {
            // No Visualize button on iPad
            return
        }
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            waitAndTap(app.buttons["Visualize Tab"])
        }
        snapshot("Sankey")
    }
    
    @MainActor
    func testTakeSankeyShareScreenshot() throws {
        // On iPad, ensure the sidebar is visible by using the system-provided button label if present.
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Try to show the sidebar if a "Show Sidebar" button exists
            if app.buttons["Show Sidebar"].waitForExistence(timeout: 2) {
                app.buttons["Show Sidebar"].tap()
            }
            // If a "Hide Sidebar" button exists, the sidebar is already visible; no further action needed.
        }

        // Navigate to Visualize tab only on iPhone; iPad may have a different layout without this tab.
        if UIDevice.current.userInterfaceIdiom != .pad {
            waitAndTap(app.buttons["Visualize Tab"])
        }

        // Wait for share button to appear and tap it; assert existence for clearer failure.
        let shareButton = app.buttons["share"]
        assertExists(shareButton, timeout: 10, message: "Expected 'share' button to exist before taking Share screenshot")
        waitAndTap(shareButton)

        snapshot("Share")
    }
}

