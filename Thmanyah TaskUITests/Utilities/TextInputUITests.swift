//
//  TextInputUITests.swift
//  Thmanyah TaskUITests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest

final class TextInputUITests: BaseUITestCase {
    
    // MARK: - Text Input Helper Tests
    func test_clearAndEnterText_shouldWorkWithSearchField() throws {
        // Given - Navigate to Search view
        navigateToTab("Search")
        
        let searchField = findSearchField()
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should be available")
        
        // When - Enter initial text
        searchField.tap()
        searchField.typeText("initial text")
        
        // Verify initial text is entered
        XCTAssertEqual(searchField.value as? String, "initial text", "Initial text should be entered")
        
        // When - Use clearAndEnterText
        searchField.clearAndEnterText("new text")
        
        // Then - Text should be replaced
        XCTAssertEqual(searchField.value as? String, "new text", "Text should be cleared and new text entered")
    }
    
    func test_clearAndEnterText_shouldHandleEmptyField() throws {
        // Given - Navigate to Search view
        navigateToTab("Search")
        
        let searchField = findSearchField()
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should be available")
        
        // When - Use clearAndEnterText on empty field
        searchField.clearAndEnterText("test text")
        
        // Then - Text should be entered
        XCTAssertEqual(searchField.value as? String, "test text", "Text should be entered in empty field")
    }
    
    func test_clearAndEnterText_shouldHandleSpecialCharacters() throws {
        // Given - Navigate to Search view
        navigateToTab("Search")
        
        let searchField = findSearchField()
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should be available")
        
        // When - Enter text with special characters
        let specialText = "test@#$%^&*()_+{}|:<>?[]\\;'\",./"
        searchField.clearAndEnterText(specialText)
        
        // Then - Special characters should be handled
        // Note: Some special characters might be filtered by the text field
        XCTAssertFalse((searchField.value as? String ?? "").isEmpty, "Some text should be entered")
    }
    
    // MARK: - Search Helper Tests
    func test_performSearch_shouldExecuteSearch() throws {
        // Given - Navigate to Search view
        navigateToTab("Search")
        
        // When - Perform search using helper
        performSearch(query: "helper test")
        
        // Then - Search should be executed
        waitForLoadingToComplete()
        
        // App should remain responsive
        verifyAppIsResponsive()
        
        // Search field should still be accessible
        let searchField = findSearchField()
        XCTAssertTrue(searchField.exists, "Search field should remain accessible")
    }
    
    func test_performSearch_shouldHandleEmptyQuery() throws {
        // Given - Navigate to Search view
        navigateToTab("Search")
        
        // When - Perform empty search
        performSearch(query: "")
        
        // Then - Should handle gracefully
        waitForLoadingToComplete()
        verifyAppIsResponsive()
    }
    
    func test_performSearch_shouldTriggerSearchButton() throws {
        // Given - Navigate to Search view
        navigateToTab("Search")
        
        let searchField = findSearchField()
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should be available")
        
        // When - Enter text manually and trigger with helper logic
        searchField.tap()
        searchField.clearAndEnterText("manual entry")
        
        // Trigger search using the logic from performSearch
        if app.keyboards.buttons["search"].exists {
            app.keyboards.buttons["search"].tap()
        } else if app.keyboards.buttons["Search"].exists {
            app.keyboards.buttons["Search"].tap()
        }
        
        // Then - Search should be triggered
        waitForLoadingToComplete()
        verifyAppIsResponsive()
    }
    
    // MARK: - findSearchField Helper Tests
    func test_findSearchField_shouldLocateSearchField() throws {
        // Given - Navigate to Search view
        navigateToTab("Search")
        
        // When - Use findSearchField helper
        let searchField = findSearchField()
        
        // Then - Should find the search field
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "findSearchField should locate search field")
        XCTAssertTrue(searchField.isHittable, "Located search field should be hittable")
    }
    
    func test_findSearchField_shouldWorkAcrossViews() throws {
        // Given - Test in different views
        
        // Home view (should not have search field)
        navigateToTab("Home")
        let homeSearchField = findSearchField()
        XCTAssertFalse(homeSearchField.exists, "Home should not have search field")
        
        // Search view (should have search field)
        navigateToTab("Search")
        let searchSearchField = findSearchField()
        XCTAssertTrue(searchSearchField.waitForExistence(timeout: 5), "Search should have search field")
        
        // Library view (should not have search field)
        navigateToTab("Library")
        let librarySearchField = findSearchField()
        XCTAssertFalse(librarySearchField.exists, "Library should not have search field")
    }
    
    // MARK: - Integration Tests
    func test_textInputHelpers_shouldWorkTogether() throws {
        // Given - Navigate to Search view
        navigateToTab("Search")
        
        // When - Use multiple helpers together
        let searchField = findSearchField()
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should be found")
        
        // Enter initial text
        searchField.clearAndEnterText("integration")
        XCTAssertEqual(searchField.value as? String, "integration", "Initial text should be set")
        
        // Clear and enter new text
        searchField.clearAndEnterText("test")
        XCTAssertEqual(searchField.value as? String, "test", "Text should be updated")
        
        // Perform search using helper
        performSearch(query: "final search")
        
        // Then - All operations should work together
        waitForLoadingToComplete()
        verifyAppIsResponsive()
    }
    
    func test_textInputHelpers_shouldHandleRapidOperations() throws {
        // Given - Navigate to Search view
        navigateToTab("Search")
        
        let searchField = findSearchField()
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should be available")
        
        // When - Perform rapid text operations
        for i in 0..<5 {
            searchField.clearAndEnterText("rapid \(i)")
            
            // Brief verification
            let currentValue = searchField.value as? String ?? ""
            XCTAssertTrue(currentValue.contains("\(i)"), "Text should contain iteration number")
        }
        
        // Then - Should handle rapid operations without issues
        verifyAppIsResponsive()
        
        // Final search should work
        performSearch(query: "rapid test complete")
        waitForLoadingToComplete()
        verifyAppIsResponsive()
    }
}
