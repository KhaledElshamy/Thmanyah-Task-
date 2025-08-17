//
//  BaseUITestCase.swift
//  Thmanyah TaskUITests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest

class BaseUITestCase: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Continue after failure for better debugging
        continueAfterFailure = false
        
        // Launch the application
        app = XCUIApplication()
        
        // Configure launch arguments for testing
        app.launchArguments.append("--uitesting")
        
        // Launch and wait for app to be ready
        app.launch()
        _ = app.wait(for: .runningForeground, timeout: 10)
    }
    
    override func tearDownWithError() throws {
        app?.terminate()
        app = nil
    }
    
    // MARK: - Common Helper Methods
    
    /// Wait for an element to appear and be hittable
    func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 10) -> Bool {
        let predicate = NSPredicate(format: "exists == true AND hittable == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    /// Wait for any of the provided elements to appear
    func waitForAnyElement(_ elements: [XCUIElement], timeout: TimeInterval = 10) -> XCUIElement? {
        let startTime = Date()
        
        while Date().timeIntervalSince(startTime) < timeout {
            for element in elements {
                if element.exists && element.isHittable {
                    return element
                }
            }
            usleep(100000) // Wait 0.1 seconds before checking again
        }
        
        return nil
    }
    
    /// Navigate to specific tab
    func navigateToTab(_ tabName: String) {
        // Try multiple selectors for tab elements
        let tabIdentifier = "\(tabName)Tab"
        
        // First try by accessibility identifier as button (since we added .isButton trait)
        let tabByIdentifier = app.buttons[tabIdentifier]
        if tabByIdentifier.exists && tabByIdentifier.isHittable {
            tabByIdentifier.tap()
            return
        }
        
        // Try by button with tab name
        let tabButton = app.buttons[tabName]
        if tabButton.exists && tabButton.isHittable {
            tabButton.tap()
            return
        }
        
        // Try as other element by identifier
        let tabOtherElement = app.otherElements[tabIdentifier]
        if tabOtherElement.exists && tabOtherElement.isHittable {
            tabOtherElement.tap()
            return
        }
        
        // Try by static text (fallback)
        let tabText = app.staticTexts[tabName]
        if tabText.exists && tabText.isHittable {
            tabText.tap()
            return
        }
        
        // Try by any button containing the tab name
        let tabButtonAny = app.buttons.containing(NSPredicate(format: "label CONTAINS[c] %@", tabName)).firstMatch
        if tabButtonAny.exists && tabButtonAny.isHittable {
            tabButtonAny.tap()
            return
        }
        
        // Try by any element containing the tab name
        let tabAny = app.otherElements.containing(NSPredicate(format: "label CONTAINS[c] %@", tabName)).firstMatch
        if tabAny.exists && tabAny.isHittable {
            tabAny.tap()
            return
        }
        
        XCTFail("\(tabName) tab could not be found or is not accessible")
    }
    
    /// Wait for loading to complete
    func waitForLoadingToComplete(timeout: TimeInterval = 15) {
        // Wait for any loading indicators to disappear
        let loadingIndicators = app.activityIndicators
        
        for indicator in loadingIndicators.allElementsBoundByIndex {
            if indicator.exists {
                // Wait for this indicator to disappear
                let predicate = NSPredicate(format: "exists == false")
                let expectation = XCTNSPredicateExpectation(predicate: predicate, object: indicator)
                _ = XCTWaiter.wait(for: [expectation], timeout: timeout)
            }
        }
    }
    
    /// Check if app is in expected state
    func verifyAppIsResponsive() {
        XCTAssertEqual(app.state, .runningForeground, "App should be running in foreground")
        
        // Verify basic navigation is working
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists {
            XCTAssertTrue(tabBar.isHittable, "Tab bar should be responsive")
        }
    }
    
    /// Scroll element to make it visible
    func scrollToElement(_ element: XCUIElement, in scrollView: XCUIElement) {
        guard scrollView.exists else { return }
        
        var attempts = 0
        let maxAttempts = 10
        
        while !element.isHittable && attempts < maxAttempts {
            scrollView.swipeUp()
            attempts += 1
        }
    }
    
    /// Handle keyboard if present
    func dismissKeyboardIfPresent() {
        if app.keyboards.firstMatch.exists {
            app.keyboards.buttons["done"].tap()
        }
    }
    
    /// Reset device orientation to portrait
    func resetOrientation() {
        XCUIDevice.shared.orientation = .portrait
    }
    
    /// Take screenshot for debugging
    func takeScreenshot(named name: String) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    /// Find tab element by name
    func findTabElement(_ tabName: String) -> XCUIElement? {
        let tabIdentifier = "\(tabName)Tab"
        
        // Try by accessibility identifier as button first (since we added .isButton trait)
        let tabByIdentifier = app.buttons[tabIdentifier]
        if tabByIdentifier.exists {
            return tabByIdentifier
        }
        
        // Try by button with tab name
        let tabButton = app.buttons[tabName]
        if tabButton.exists {
            return tabButton
        }
        
        // Try as other element by identifier
        let tabOtherElement = app.otherElements[tabIdentifier]
        if tabOtherElement.exists {
            return tabOtherElement
        }
        
        // Try by static text
        let tabText = app.staticTexts[tabName]
        if tabText.exists && tabText.isHittable {
            return tabText
        }
        
        // Try by any button containing the tab name
        let tabButtonAny = app.buttons.containing(NSPredicate(format: "label CONTAINS[c] %@", tabName)).firstMatch
        if tabButtonAny.exists {
            return tabButtonAny
        }
        
        // Try by any element containing the tab name
        let tabAny = app.otherElements.containing(NSPredicate(format: "label CONTAINS[c] %@", tabName)).firstMatch
        if tabAny.exists {
            return tabAny
        }
        
        return nil
    }
    
    /// Find search field using multiple selectors
    func findSearchField() -> XCUIElement {
        // Try different possible selectors for the search field
        if app.searchFields.firstMatch.exists {
            return app.searchFields.firstMatch
        } else if app.textFields.firstMatch.exists {
            return app.textFields.firstMatch
        } else {
            // Return the first match even if it doesn't exist for consistent testing
            return app.searchFields.firstMatch
        }
    }
    
    /// Perform search with given query
    func performSearch(query: String) {
        let searchField = findSearchField()
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should be available")
        
        searchField.tap()
        searchField.clearAndEnterText(query)
        
        // Trigger search (try search button or return key)
        if app.keyboards.buttons["search"].exists {
            app.keyboards.buttons["search"].tap()
        } else if app.keyboards.buttons["Search"].exists {
            app.keyboards.buttons["Search"].tap()
        } else {
            // Fallback to return key
            searchField.typeText("\n")
        }
    }
    
    /// Check if currently on Search view using multiple indicators
    func isOnSearchView() -> Bool {
        // Try multiple ways to detect Search view
        let searchField = findSearchField()
        let searchTitle = app.staticTexts["Search"]
        let searchNavigation = app.navigationBars.containing(NSPredicate(format: "identifier CONTAINS 'Search' OR label CONTAINS 'Search'")).firstMatch
        
        return searchField.exists || searchTitle.exists || searchNavigation.exists
    }
    
    /// Wait for Search view to appear
    func waitForSearchView(timeout: TimeInterval = 5) -> Bool {
        let startTime = Date()
        
        while Date().timeIntervalSince(startTime) < timeout {
            if isOnSearchView() {
                return true
            }
            usleep(100000) // Wait 0.1 seconds before checking again
        }
        
        return false
    }
}

// MARK: - XCUIElement Extension for UI Tests
extension XCUIElement {
    /// Clear existing text and enter new text
    func clearAndEnterText(_ text: String) {
        guard self.exists else { return }
        
        self.tap()
        
        // Clear existing text if any
        if let currentValue = self.value as? String, !currentValue.isEmpty {
            // Select all text
            self.press(forDuration: 1.0)
            
            // Check if "Select All" menu item appears
            let app = XCUIApplication()
            if app.menuItems["Select All"].exists {
                app.menuItems["Select All"].tap()
                app.keys["delete"].tap()
            } else {
                // Alternative: use keyboard to select all and delete
                self.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentValue.count))
            }
        }
        
        // Enter new text
        self.typeText(text)
    }
    
    /// Force clear text field using coordinate-based selection
    func forceClearText() {
        guard self.exists else { return }
        
        self.tap()
        
        // Double tap to select all text
        self.doubleTap()
        
        // Delete selected text
        let app = XCUIApplication()
        if app.keys["delete"].exists {
            app.keys["delete"].tap()
        }
    }
    
    /// Clear text using backspace repeatedly
    func clearTextWithBackspace() {
        guard self.exists else { return }
        
        self.tap()
        
        // Get current text length
        if let currentValue = self.value as? String, !currentValue.isEmpty {
            // Delete each character
            for _ in 0..<currentValue.count {
                self.typeText(XCUIKeyboardKey.delete.rawValue)
            }
        }
    }
}

// MARK: - Common UI Test Expectations
extension BaseUITestCase {
    
    /// Verify that content loads within reasonable time
    func expectContentToLoad(timeout: TimeInterval = 15) {
        let scrollView = app.scrollViews.firstMatch
        let emptyState = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'No'")).firstMatch
        let errorState = app.buttons["Retry"]
        
        let contentLoaded = waitForAnyElement([scrollView, emptyState, errorState], timeout: timeout)
        XCTAssertNotNil(contentLoaded, "Some form of content should load within \(timeout) seconds")
    }
    
    /// Verify navigation elements are present
    func expectNavigationToBePresent() {
        let navigationBars = app.navigationBars
        XCTAssertGreaterThan(navigationBars.count, 0, "Navigation should be present")
        
        let tabBars = app.tabBars
        if tabBars.count > 0 {
            XCTAssertTrue(tabBars.firstMatch.exists, "Tab bar should be present")
        }
    }
    
    /// Verify accessibility compliance
    func expectAccessibilityCompliance() {
        // Check that main interactive elements have accessibility labels
        let buttons = app.buttons.allElementsBoundByIndex
        let textFields = app.textFields.allElementsBoundByIndex
        let otherElements = app.otherElements.allElementsBoundByIndex
        
        for button in buttons {
            if button.exists && button.isHittable {
                XCTAssertFalse(button.label.isEmpty, "Button should have accessibility label")
            }
        }
        
        for textField in textFields {
            if textField.exists {
                XCTAssertFalse(textField.label.isEmpty, "Text field should have accessibility label")
            }
        }
        
        // Check tab elements specifically
        for element in otherElements {
            if element.identifier.hasSuffix("Tab") && element.exists && element.isHittable {
                XCTAssertFalse(element.label.isEmpty, "Tab element should have accessibility label")
            }
        }
    }
}

// MARK: - Performance Testing Helpers
extension BaseUITestCase {
    
    /// Measure app launch time
    func measureAppLaunchTime() {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            let freshApp = XCUIApplication()
            freshApp.launch()
            freshApp.terminate()
        }
    }
    
    /// Measure scrolling performance
    func measureScrollingPerformance(in scrollView: XCUIElement) {
        guard scrollView.exists else {
            XCTFail("Scroll view must exist for performance testing")
            return
        }
        
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            for _ in 0..<10 {
                scrollView.swipeUp()
            }
            for _ in 0..<10 {
                scrollView.swipeDown()
            }
        }
    }
}
