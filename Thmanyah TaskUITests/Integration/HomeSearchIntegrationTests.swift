//
//  HomeSearchIntegrationTests.swift
//  Thmanyah TaskUITests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest

final class HomeSearchIntegrationTests: BaseUITestCase {
    
    // MARK: - Cross-Navigation Tests
    func test_navigationBetweenHomeAndSearch_shouldMaintainState() throws {
        // Given - Start on Home
        navigateToTab("Home")
        expectContentToLoad()
        
        // When - Navigate to Search
        navigateToTab("Search")
        
        // Then - Search should load
        let searchNavigation = app.navigationBars["Search"]
        XCTAssertTrue(searchNavigation.waitForExistence(timeout: 5), "Search should load")
        
        // When - Navigate back to Home
        navigateToTab("Home")
        
        // Then - Home should be restored
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Home should be restored")
    }
    
    func test_searchFromHomeAndReturn_shouldPreserveHomeContent() throws {
        // Given - Home is loaded with content
        navigateToTab("Home")
        expectContentToLoad()
        
        let homeScrollView = app.scrollViews.firstMatch
        XCTAssertTrue(homeScrollView.waitForExistence(timeout: 10), "Home content should be loaded")
        
        // When - Perform search in Search tab
        navigateToTab("Search")
        
        let searchField = app.textFields.firstMatch.exists ? app.textFields.firstMatch : app.searchFields.firstMatch
        if searchField.waitForExistence(timeout: 5) {
            searchField.tap()
            searchField.typeText("integration test")
            app.keyboards.buttons["search"].tap()
        }
        
        // When - Return to Home
        navigateToTab("Home")
        
        // Then - Home content should still be there
        XCTAssertTrue(homeScrollView.waitForExistence(timeout: 5), "Home content should be preserved")
    }
    
    // MARK: - Tab State Management Tests
    func test_multipleTabSwitches_shouldMaintainPerformance() throws {
        // Given - App is loaded
        
        // When - Switch between tabs multiple times
        for i in 0..<5 {
            navigateToTab("Home")
            waitForLoadingToComplete()
            
            navigateToTab("Search")
            waitForLoadingToComplete()
            
            // Verify app remains responsive
            verifyAppIsResponsive()
        }
        
        // Then - App should still be functional
        expectNavigationToBePresent()
        expectContentToLoad()
    }
    
    func test_backgroundAndForeground_shouldRestoreState() throws {
        // Given - Navigate through app
        navigateToTab("Home")
        expectContentToLoad()
        
        navigateToTab("Search")
        let searchField = app.textFields.firstMatch.exists ? app.textFields.firstMatch : app.searchFields.firstMatch
        if searchField.waitForExistence(timeout: 5) {
            searchField.tap()
            searchField.typeText("background test")
        }
        
        // When - Background and foreground app
        XCUIDevice.shared.press(.home)
        app.activate()
        
        // Then - Search state should be maintained
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should be restored")
        
        // Navigation should still work
        navigateToTab("Home")
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Home should be accessible")
    }
    
    // MARK: - Error Recovery Tests
    func test_errorInOneTab_shouldNotAffectOther() throws {
        // Given - Home is working
        navigateToTab("Home")
        expectContentToLoad()
        
        // When - Potentially cause error in Search (if possible)
        navigateToTab("Search")
        
        let searchField = app.textFields.firstMatch.exists ? app.textFields.firstMatch : app.searchFields.firstMatch
        if searchField.waitForExistence(timeout: 5) {
            searchField.tap()
            searchField.typeText("error_test_very_long_query_that_might_cause_issues_" + String(repeating: "a", count: 100))
            app.keyboards.buttons["search"].tap()
        }
        
        // Wait for potential error
        sleep(2)
        
        // When - Return to Home
        navigateToTab("Home")
        
        // Then - Home should still work
        let homeScrollView = app.scrollViews.firstMatch
        XCTAssertTrue(homeScrollView.waitForExistence(timeout: 10), "Home should still be functional")
        
        verifyAppIsResponsive()
    }
    
    // MARK: - Memory Management Tests
    func test_extendedUsage_shouldNotCauseMemoryIssues() throws {
        // Simulate extended usage pattern
        for cycle in 0..<3 {
            // Home usage
            navigateToTab("Home")
            expectContentToLoad()
            
            let homeScrollView = app.scrollViews.firstMatch
            if homeScrollView.exists {
                // Scroll through content
                for _ in 0..<5 {
                    homeScrollView.swipeUp()
                }
                for _ in 0..<5 {
                    homeScrollView.swipeDown()
                }
            }
            
            // Search usage
            navigateToTab("Search")
            let searchField = app.textFields.firstMatch.exists ? app.textFields.firstMatch : app.searchFields.firstMatch
            
            if searchField.waitForExistence(timeout: 5) {
                searchField.tap()
                searchField.clearAndEnterText("cycle \(cycle)")
                app.keyboards.buttons["search"].tap()
                
                waitForLoadingToComplete()
                
                let searchScrollView = app.scrollViews.firstMatch
                if searchScrollView.exists {
                    searchScrollView.swipeUp()
                    searchScrollView.swipeDown()
                }
            }
            
            // Verify app remains responsive
            verifyAppIsResponsive()
        }
        
        // Final verification
        expectNavigationToBePresent()
    }
    
    // MARK: - Accessibility Integration Tests
    func test_accessibilityAcrossViews_shouldBeConsistent() throws {
        // Test Home accessibility
        navigateToTab("Home")
        expectContentToLoad()
        expectAccessibilityCompliance()
        
        // Test Search accessibility
        navigateToTab("Search")
        expectAccessibilityCompliance()
        
        // Tab navigation should be accessible
        let homeTab = findTabElement("Home")
        let searchTab = findTabElement("Search")
        
        XCTAssertNotNil(homeTab, "Home tab should exist")
        XCTAssertTrue(homeTab?.isHittable ?? false, "Home tab should be accessible")
        XCTAssertNotNil(searchTab, "Search tab should exist")
        XCTAssertTrue(searchTab?.isHittable ?? false, "Search tab should be accessible")
    }
    
    // MARK: - Orientation Integration Tests
    func test_orientationChanges_acrossViews_shouldWork() throws {
        // Test in portrait
        resetOrientation()
        
        navigateToTab("Home")
        expectContentToLoad()
        
        navigateToTab("Search")
        expectContentToLoad()
        
        // Test in landscape
        XCUIDevice.shared.orientation = .landscapeLeft
        
        // Both views should still work
        navigateToTab("Home")
        expectContentToLoad()
        
        navigateToTab("Search")
        expectContentToLoad()
        
        // Return to portrait
        resetOrientation()
        
        // Should still work
        expectNavigationToBePresent()
        verifyAppIsResponsive()
    }
    
    // MARK: - Performance Integration Tests
    func test_overallAppPerformance_shouldMeetExpectations() throws {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            // Simulate typical user flow
            navigateToTab("Home")
            waitForLoadingToComplete()
            
            let homeScrollView = app.scrollViews.firstMatch
            if homeScrollView.exists {
                homeScrollView.swipeUp()
                homeScrollView.swipeUp()
            }
            
            navigateToTab("Search")
            waitForLoadingToComplete()
            
            let searchField = app.textFields.firstMatch.exists ? app.textFields.firstMatch : app.searchFields.firstMatch
            if searchField.waitForExistence(timeout: 5) {
                searchField.tap()
                searchField.typeText("performance")
                app.keyboards.buttons["search"].tap()
                waitForLoadingToComplete()
            }
            
            navigateToTab("Home")
            waitForLoadingToComplete()
        }
    }
    
    // MARK: - Edge Case Tests
    func test_rapidTabSwitching_shouldHandleGracefully() throws {
        // Rapidly switch tabs
        for _ in 0..<10 {
            navigateToTab("Home")
            navigateToTab("Search")
        }
        
        // App should remain responsive
        verifyAppIsResponsive()
        
        // Final state should be valid
        let searchNavigation = app.navigationBars["Search"]
        XCTAssertTrue(searchNavigation.exists, "Should end on valid search view")
    }
    
    func test_interruptedOperations_shouldRecover() throws {
        // Start operation in Home
        navigateToTab("Home")
        let homeScrollView = app.scrollViews.firstMatch
        if homeScrollView.waitForExistence(timeout: 10) {
            homeScrollView.swipeUp() // Start scrolling
        }
        
        // Immediately switch to Search
        navigateToTab("Search")
        
        // Start search operation
        let searchField = app.textFields.firstMatch.exists ? app.textFields.firstMatch : app.searchFields.firstMatch
        if searchField.waitForExistence(timeout: 5) {
            searchField.tap()
            searchField.typeText("interrupt")
        }
        
        // Immediately switch back to Home
        navigateToTab("Home")
        
        // Both views should recover gracefully
        expectContentToLoad()
        verifyAppIsResponsive()
    }
}
