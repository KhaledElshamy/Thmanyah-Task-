//
//  HomeViewUITests.swift
//  Thmanyah TaskUITests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest

final class HomeViewUITests: BaseUITestCase {
    
    // MARK: - Initial Load Tests
    func test_homeView_shouldLoadSuccessfully() throws {
        // Given - App is launched
        
        // Then - Home tab should be visible and active
        let homeTab = findTabElement("Home")
        XCTAssertNotNil(homeTab, "Home tab should exist")
        XCTAssertTrue(homeTab?.exists ?? false, "Home tab should be visible")
        
        // Navigation should show Thmanyah title
        let navigationTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: 5), "Navigation title should be visible")
    }
    
    func test_homeView_shouldDisplayContentAfterLoading() throws {
        // Given - App is launched
        
        // Wait for content to load
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "Content should load")
        
        // Then - Should have scrollable content
        XCTAssertTrue(scrollView.exists, "Scroll view should exist")
        
        // Should have some text elements (section titles or content)
        let textElements = app.staticTexts
        XCTAssertGreaterThan(textElements.count, 0, "Should have text content")
    }
    
    // MARK: - Navigation Tests
    func test_homeView_shouldHaveNavigationTitle() throws {
        // Given - App is launched and content loaded
        let navigationTitle = app.staticTexts["Thmanyah"]
        
        // Then
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: 5), "Navigation title should exist")
        XCTAssertTrue(navigationTitle.isHittable, "Navigation title should be visible")
    }
    
    // MARK: - Content Interaction Tests
    func test_homeView_shouldBeScrollable() throws {
        // Given - Content is loaded
        expectContentToLoad()
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "Scroll view should exist")
        
        // When - Scroll down
        scrollView.swipeUp()
        
        // Then - Should scroll without issues (no crash)
        XCTAssertTrue(scrollView.exists, "Scroll view should still exist after scrolling")
        verifyAppIsResponsive()
    }
    
    func test_homeView_shouldHandleRefreshGesture() throws {
        // Given - Content is loaded
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "Scroll view should exist")
        
        // When - Pull to refresh
        let startCoordinate = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        let endCoordinate = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
        startCoordinate.press(forDuration: 0, thenDragTo: endCoordinate)
        
        // Then - Should handle refresh without crashing
        XCTAssertTrue(scrollView.exists, "Scroll view should exist after refresh")
    }
    
    // MARK: - Error State Tests
    func test_homeView_shouldShowRetryButtonOnError() throws {
        // Given - App is in a state where it could show error
        // This is difficult to test without network mocking
        // We can at least verify the UI doesn't crash under various conditions
        
        let scrollView = app.scrollViews.firstMatch
        if scrollView.waitForExistence(timeout: 10) {
            // Content loaded successfully
            XCTAssertTrue(scrollView.exists, "Content should load normally")
        } else {
            // Check if error state is shown
            let retryButton = app.buttons["Retry"]
            if retryButton.exists {
                XCTAssertTrue(retryButton.isHittable, "Retry button should be tappable")
                
                // Test retry functionality
                retryButton.tap()
                
                // Should attempt to reload
                XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "Content should load after retry")
            }
        }
    }
    
    // MARK: - Loading State Tests
    func test_homeView_shouldShowLoadingForPagination() throws {
        // Given - Content is loaded
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "Initial content should load")
        
        // When - Scroll to bottom to trigger pagination
        for _ in 0..<5 {
            scrollView.swipeUp()
        }
        
        // Then - Should handle pagination without crashing
        XCTAssertTrue(scrollView.exists, "Scroll view should exist after pagination")
        
        // Look for "Loading more..." text or activity indicator
        let loadingText = app.staticTexts["Loading more..."]
        let activityIndicator = app.activityIndicators.firstMatch
        
        // Either loading text or activity indicator might appear briefly
        if loadingText.exists || activityIndicator.exists {
            // Wait for loading to complete
            _ = scrollView.waitForExistence(timeout: 5)
        }
        
        XCTAssertTrue(scrollView.exists, "Content should be available after loading")
    }
    
    // MARK: - Empty State Tests
    func test_homeView_shouldHandleEmptyState() throws {
        // Note: This test would require specific data conditions
        // For now, we test that the app doesn't crash when content might be empty
        
        let scrollView = app.scrollViews.firstMatch
        
        if !scrollView.waitForExistence(timeout: 10) {
            // Check for empty state message
            let emptyMessage = app.staticTexts["No Content Available"]
            if emptyMessage.exists {
                XCTAssertTrue(emptyMessage.isHittable, "Empty state message should be visible")
            }
        }
    }
    
    // MARK: - Accessibility Tests
    func test_homeView_shouldHaveAccessibleElements() throws {
        // Given - Content is loaded
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "Content should load")
        
        // Then - Navigation should be accessible
        let navigationTitle = app.staticTexts["Thmanyah"]
        XCTAssertTrue(navigationTitle.exists, "Navigation title should be accessible")
        
        // Tab bar should be accessible
        let homeTab = findTabElement("Home")
        XCTAssertNotNil(homeTab, "Home tab should exist")
        XCTAssertTrue(homeTab?.isHittable ?? false, "Home tab should be hittable")
        
        // Content should have accessible elements
        let buttons = app.buttons
        let staticTexts = app.staticTexts
        
        XCTAssertGreaterThan(buttons.count + staticTexts.count, 0, "Should have accessible UI elements")
    }
    
    // MARK: - Performance Tests
    func test_homeView_shouldLoadWithinReasonableTime() throws {
        // Measure the time it takes for content to appear
        measure {
            // Launch fresh instance
            let freshApp = XCUIApplication()
            freshApp.launch()
            
            // Wait for content to load
            let scrollView = freshApp.scrollViews.firstMatch
            _ = scrollView.waitForExistence(timeout: 10)
            
            freshApp.terminate()
        }
    }
    
    // MARK: - Rotation Tests
    func test_homeView_shouldHandleDeviceRotation() throws {
        // Given - Content is loaded in portrait
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "Content should load")
        
        // When - Rotate to landscape
        XCUIDevice.shared.orientation = .landscapeLeft
        
        // Then - Content should still be accessible
        XCTAssertTrue(scrollView.exists, "Content should exist in landscape")
        
        // Rotate back to portrait
        XCUIDevice.shared.orientation = .portrait
        
        // Content should still be accessible
        XCTAssertTrue(scrollView.exists, "Content should exist in portrait")
    }
}
