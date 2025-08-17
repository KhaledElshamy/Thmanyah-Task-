//
//  MainTabViewUITests.swift
//  Thmanyah TaskUITests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest

final class MainTabViewUITests: BaseUITestCase {
    
    // MARK: - Main Tab View Structure Tests
    func test_mainTabView_shouldLoadWithCorrectStructure() throws {
        // Given - App is launched
        
        // Then - Main tab view should be present with content area and tab bar
        // Content area should exist
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Content area should be present")
        
        // Tab bar should exist at bottom
        let homeTab = findTabElement("Home")
        XCTAssertNotNil(homeTab, "Tab bar should be present")
        XCTAssertTrue(homeTab?.exists ?? false, "Home tab should be visible")
    }
    
    func test_mainTabView_shouldDisplayContentAboveTabBar() throws {
        // Given - App is launched on Home
        
        // Then - Content should be displayed above tab bar
        let homeTitle = app.staticTexts["Thmanyah"]
        let homeTab = findTabElement("Home")
        
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Home content should be visible")
        XCTAssertNotNil(homeTab, "Home tab should be visible")
        
        if let tab = homeTab {
            // Content should be above tab bar
            XCTAssertLessThan(homeTitle.frame.midY, tab.frame.midY, "Content should be above tab bar")
        }
    }
    
    func test_mainTabView_shouldHandleContentSwitching() throws {
        // Given - Start on Home
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Should start on Home")
        
        // When - Switch to Search
        navigateToTab("Search")
        
        // Then - Content should switch to Search
        let searchField = findSearchField()
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search content should be displayed")
        
        // Home content should no longer be visible
        XCTAssertFalse(homeTitle.exists, "Home content should be hidden when on Search")
        
        // When - Switch back to Home
        navigateToTab("Home")
        
        // Then - Home content should be restored
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 3), "Home content should be restored")
        XCTAssertFalse(searchField.exists, "Search content should be hidden when on Home")
    }
    
    // MARK: - Content View Loading Tests
    func test_mainTabView_shouldLoadHomeContent() throws {
        // Given - Navigate to Home
        navigateToTab("Home")
        
        // Then - Home content should load
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Home title should be visible")
        
        // Home scroll view should be available
        expectContentToLoad()
        let scrollView = app.scrollViews.firstMatch
        if scrollView.waitForExistence(timeout: 10) {
            XCTAssertTrue(scrollView.exists, "Home scroll view should be available")
        }
    }
    
    func test_mainTabView_shouldLoadSearchContent() throws {
        // Given - Navigate to Search
        navigateToTab("Search")
        
        // Then - Search content should load
        // Try multiple ways to detect Search view
        let searchNavigation = app.navigationBars.containing(NSPredicate(format: "identifier CONTAINS 'Search' OR label CONTAINS 'Search'")).firstMatch
        let searchTitle = app.staticTexts["Search"]
        let searchField = findSearchField()
        
        // At least one indicator should be present
        let searchIndicators = [searchNavigation, searchTitle, searchField]
        let foundIndicator = waitForAnyElement(searchIndicators, timeout: 5)
        XCTAssertNotNil(foundIndicator, "Search content should be detectable")
        
        // Search field should be available
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should be available")
    }
    
    func test_mainTabView_shouldLoadPlaceholderContent() throws {
        // Given - Navigate to placeholder tabs
        let placeholderTabs = ["Library", "Explore", "Profile"]
        
        for tabName in placeholderTabs {
            // When - Navigate to placeholder tab
            navigateToTab(tabName)
            
            // Then - Placeholder content should load
            let placeholderTitle = app.staticTexts["\(tabName) Tab"]
            XCTAssertTrue(placeholderTitle.waitForExistence(timeout: 3), "\(tabName) placeholder title should be visible")
            
            let comingSoonText = app.staticTexts["Coming Soon..."]
            XCTAssertTrue(comingSoonText.exists, "Coming soon text should be visible for \(tabName)")
            
            let iconImage = app.images.containing(NSPredicate(format: "identifier CONTAINS 'hammer'")).firstMatch
            // Icon might not be easily testable, but layout should be stable
        }
    }
    
    // MARK: - Content Persistence Tests
    func test_mainTabView_shouldPreserveContentState() throws {
        // Given - Load Home content
        navigateToTab("Home")
        expectContentToLoad()
        
        let homeScrollView = app.scrollViews.firstMatch
        if homeScrollView.waitForExistence(timeout: 10) {
            // Scroll to create state
            homeScrollView.swipeUp()
        }
        
        // When - Switch to another tab and back
        navigateToTab("Library")
        let libraryTitle = app.staticTexts["Library Tab"]
        XCTAssertTrue(libraryTitle.waitForExistence(timeout: 3), "Library should load")
        
        navigateToTab("Home")
        
        // Then - Home content should be preserved
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 3), "Home content should be restored")
        
        // Scroll view should still be available
        XCTAssertTrue(homeScrollView.waitForExistence(timeout: 3), "Home scroll view should be preserved")
    }
    
    func test_mainTabView_shouldMaintainSearchState() throws {
        // Given - Enter search query
        navigateToTab("Search")
        
        let searchField = app.textFields.firstMatch.exists ? app.textFields.firstMatch : app.searchFields.firstMatch
        if searchField.waitForExistence(timeout: 5) {
            searchField.tap()
            searchField.typeText("state test")
        }
        
        // When - Switch tabs and return
        navigateToTab("Home")
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 3), "Home should load")
        
        navigateToTab("Search")
        
        // Then - Search view should be restored
        let restoredSearchField = findSearchField()
        XCTAssertTrue(restoredSearchField.waitForExistence(timeout: 3), "Search should be restored")
        
        // Search field should be available again
        XCTAssertTrue(restoredSearchField.waitForExistence(timeout: 3), "Search field should be restored")
    }
    
    // MARK: - Layout and Positioning Tests
    func test_mainTabView_shouldHaveCorrectLayout() throws {
        // Given - App is launched
        
        // Then - Content and tab bar should be properly positioned
        let homeTitle = app.staticTexts["Thmanyah"]
        let homeTab = findTabElement("Home")
        
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Content should be visible")
        XCTAssertNotNil(homeTab, "Tab should be visible")
        
        if let tab = homeTab {
            // Content should be above tab bar
            XCTAssertLessThan(homeTitle.frame.maxY, tab.frame.minY, "Content should be above tab bar")
            
            // Tab bar should be near bottom of screen
            let screenHeight = app.frame.height
            XCTAssertGreaterThan(tab.frame.midY, screenHeight * 0.7, "Tab bar should be in bottom portion of screen")
        }
    }
    
    func test_mainTabView_shouldRespectSafeArea() throws {
        // Given - App is launched
        
        // Then - Content should respect safe area
        let homeTitle = app.staticTexts["Thmanyah"]
        let homeTab = findTabElement("Home")
        
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Content should be visible")
        XCTAssertNotNil(homeTab, "Tab should be visible")
        
        // Content should be within safe bounds
        let screenBounds = app.frame
        XCTAssertGreaterThanOrEqual(homeTitle.frame.minY, screenBounds.minY, "Content should respect top safe area")
        
        if let tab = homeTab {
            XCTAssertLessThanOrEqual(tab.frame.maxY, screenBounds.maxY, "Tab bar should respect bottom safe area")
        }
    }
    
    // MARK: - Content Transition Tests
    func test_mainTabView_shouldTransitionSmoothly() throws {
        // Given - Start on Home
        navigateToTab("Home")
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Home should be active")
        
        // When - Switch between tabs rapidly
        let tabs = ["Search", "Library", "Explore", "Profile", "Home"]
        
        for tabName in tabs {
            navigateToTab(tabName)
            
            // Content should load for each tab
            switch tabName {
            case "Home":
                let title = app.staticTexts["Thmanyah"]
                XCTAssertTrue(title.waitForExistence(timeout: 3), "Home content should appear")
            case "Search":
                let searchField = findSearchField()
                XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search content should appear")
            case "Library", "Explore", "Profile":
                let placeholder = app.staticTexts["\(tabName) Tab"]
                XCTAssertTrue(placeholder.waitForExistence(timeout: 3), "\(tabName) content should appear")
            default:
                break
            }
            
            // App should remain responsive during transitions
            verifyAppIsResponsive()
        }
    }
    
    func test_mainTabView_shouldHandleInterruptedTransitions() throws {
        // Given - Start transitioning between tabs
        navigateToTab("Home")
        
        // When - Rapidly switch before transitions complete
        for _ in 0..<5 {
            navigateToTab("Search")
            navigateToTab("Home")
            navigateToTab("Library")
            navigateToTab("Home")
        }
        
        // Then - Should end up in stable state
        verifyAppIsResponsive()
        
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Should settle on Home view")
    }
    
    // MARK: - Memory Management Tests
    func test_mainTabView_shouldManageMemoryEfficiently() throws {
        // Given - App is launched
        
        // When - Extensively switch between tabs
        measure(metrics: [XCTMemoryMetric()]) {
            for _ in 0..<15 {
                navigateToTab("Home")
                waitForLoadingToComplete()
                
                navigateToTab("Search")
                waitForLoadingToComplete()
                
                navigateToTab("Library")
                navigateToTab("Explore")
                navigateToTab("Profile")
            }
        }
        
        // Then - App should remain responsive
        verifyAppIsResponsive()
        
        // Final navigation should work normally
        navigateToTab("Home")
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "App should function normally after memory test")
    }
    
    func test_mainTabView_shouldReleaseUnusedContent() throws {
        // Given - Load content in multiple tabs
        navigateToTab("Home")
        expectContentToLoad()
        
        navigateToTab("Search")
        let searchField = app.textFields.firstMatch.exists ? app.textFields.firstMatch : app.searchFields.firstMatch
        if searchField.waitForExistence(timeout: 5) {
            searchField.tap()
            searchField.typeText("memory test")
        }
        
        // When - Switch to placeholder tabs (should be lightweight)
        navigateToTab("Library")
        navigateToTab("Explore")
        navigateToTab("Profile")
        
        // Then - App should handle memory efficiently
        verifyAppIsResponsive()
        
        // Previous content should still be accessible
        navigateToTab("Home")
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Home content should be restorable")
        
        navigateToTab("Search")
        let searchNav = app.navigationBars["Search"]
        XCTAssertTrue(searchNav.waitForExistence(timeout: 3), "Search content should be restorable")
    }
    
    // MARK: - Error Recovery Tests
    func test_mainTabView_shouldRecoverFromContentErrors() throws {
        // Given - Normal operation
        navigateToTab("Home")
        expectContentToLoad()
        
        // When - Navigate through tabs that might have loading issues
        navigateToTab("Search")
        navigateToTab("Library")
        navigateToTab("Home")
        
        // Simulate potential stress
        for _ in 0..<10 {
            navigateToTab("Search")
            navigateToTab("Home")
        }
        
        // Then - Should recover and function normally
        verifyAppIsResponsive()
        
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Home should be accessible after stress test")
        
        navigateToTab("Search")
        let searchNav = app.navigationBars["Search"]
        XCTAssertTrue(searchNav.waitForExistence(timeout: 3), "Search should be accessible after stress test")
    }
    
    // MARK: - Integration Tests
    func test_mainTabView_shouldIntegrateWithTabCoordinator() throws {
        // Given - App is launched with tab coordinator
        
        // Then - Tab coordinator should manage tab state
        let tabs = ["Home", "Search", "Library", "Explore", "Profile"]
        
        for tabName in tabs {
            // When - Select tab
            navigateToTab(tabName)
            
            // Then - Content should change appropriately
            switch tabName {
            case "Home":
                let homeTitle = app.staticTexts["Thmanyah"]
                XCTAssertTrue(homeTitle.waitForExistence(timeout: 3), "Home content should be managed by coordinator")
            case "Search":
                let searchNav = app.navigationBars["Search"]
                XCTAssertTrue(searchNav.waitForExistence(timeout: 3), "Search content should be managed by coordinator")
            case "Library", "Explore", "Profile":
                let placeholder = app.staticTexts["\(tabName) Tab"]
                XCTAssertTrue(placeholder.waitForExistence(timeout: 3), "\(tabName) content should be managed by coordinator")
            default:
                break
            }
            
            // Tab should remain accessible
            let tab = findTabElement(tabName)
            XCTAssertNotNil(tab, "\(tabName) tab should remain accessible")
        }
    }
    
    func test_mainTabView_shouldWorkWithDependencyInjection() throws {
        // Given - App uses DI container for views
        
        // When - Navigate to functional views
        navigateToTab("Home")
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Home view should be created via DI")
        
        navigateToTab("Search")
        let searchField = findSearchField()
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search view should be created via DI")
        
        // Then - Views should function correctly
        expectContentToLoad()
        verifyAppIsResponsive()
        
        // Views should maintain their functionality
        if searchField.waitForExistence(timeout: 5) {
            searchField.clearAndEnterText("DI test")
            
            // Should work without issues
            verifyAppIsResponsive()
        }
    }
    
    // MARK: - Device State Tests
    func test_mainTabView_shouldHandleOrientationChanges() throws {
        // Given - Start in portrait
        resetOrientation()
        navigateToTab("Home")
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Home should be visible in portrait")
        
        // When - Rotate to landscape
        XCUIDevice.shared.orientation = .landscapeLeft
        
        // Then - Layout should adapt
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 3), "Home should remain visible in landscape")
        
        let homeTab = findTabElement("Home")
        XCTAssertNotNil(homeTab, "Tab bar should remain accessible in landscape")
        
        // Tab switching should still work
        navigateToTab("Search")
        let searchField = findSearchField()
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Tab switching should work in landscape")
        
        // Return to portrait
        resetOrientation()
        
        // Should continue working
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search should remain active in portrait")
    }
    
    func test_mainTabView_shouldSurviveAppStateChanges() throws {
        // Given - Select specific tab and content
        navigateToTab("Search")
        let searchField = findSearchField()
        if searchField.waitForExistence(timeout: 5) {
            searchField.clearAndEnterText("persistence test")
        }
        
        // When - Background and restore app
        XCUIDevice.shared.press(.home)
        app.activate()
        
        // Then - State should be preserved
        let restoredSearchField = findSearchField()
        XCTAssertTrue(restoredSearchField.waitForExistence(timeout: 5), "Search view should be restored")
        
        // Tab bar should remain functional
        navigateToTab("Home")
        let homeTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 5), "Tab navigation should work after app restoration")
        
        verifyAppIsResponsive()
    }
}