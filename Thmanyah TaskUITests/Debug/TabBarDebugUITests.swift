//
//  TabBarDebugUITests.swift
//  Thmanyah TaskUITests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest

final class TabBarDebugUITests: BaseUITestCase {
    
    // MARK: - Debug Element Detection
    func test_debug_printAllAvailableElements() throws {
        // Given - App is launched
        
        // When - Print all available elements
        print("🔍 DEBUG: Available UI Elements")
        print("================================")
        
        // Check buttons
        print("📱 BUTTONS:")
        let buttons = app.buttons.allElementsBoundByIndex
        for (index, button) in buttons.enumerated() {
            if button.exists {
                print("  [\(index)] Label: '\(button.label)' | Identifier: '\(button.identifier)' | Exists: \(button.exists) | Hittable: \(button.isHittable)")
            }
        }
        
        // Check other elements
        print("\n🔧 OTHER ELEMENTS:")
        let otherElements = app.otherElements.allElementsBoundByIndex
        for (index, element) in otherElements.enumerated() {
            if element.exists {
                print("  [\(index)] Label: '\(element.label)' | Identifier: '\(element.identifier)' | Exists: \(element.exists) | Hittable: \(element.isHittable)")
            }
        }
        
        // Check static texts
        print("\n📝 STATIC TEXTS:")
        let staticTexts = app.staticTexts.allElementsBoundByIndex
        for (index, text) in staticTexts.enumerated() {
            if text.exists {
                print("  [\(index)] Label: '\(text.label)' | Identifier: '\(text.identifier)' | Exists: \(text.exists) | Hittable: \(text.isHittable)")
            }
        }
        
        // Check images
        print("\n🖼 IMAGES:")
        let images = app.images.allElementsBoundByIndex
        for (index, image) in images.enumerated() {
            if image.exists {
                print("  [\(index)] Label: '\(image.label)' | Identifier: '\(image.identifier)' | Exists: \(image.exists) | Hittable: \(image.isHittable)")
            }
        }
        
        print("================================")
        
        // This test always passes - it's just for debugging
        XCTAssertTrue(true, "Debug information printed")
    }
    
    func test_debug_searchForTabElements() throws {
        // Given - App is launched
        
        print("🔍 DEBUG: Searching for Tab Elements")
        print("====================================")
        
        let tabNames = ["Home", "Search", "Library", "Explore", "Profile"]
        
        for tabName in tabNames {
            print("\n🎯 Searching for \(tabName) tab:")
            
            let tabIdentifier = "\(tabName)Tab"
            
            // Try different element types
            let buttonById = app.buttons[tabIdentifier]
            let buttonByName = app.buttons[tabName]
            let otherById = app.otherElements[tabIdentifier]
            let otherByName = app.otherElements[tabName]
            let textByName = app.staticTexts[tabName]
            
            print("  🔘 Button by ID ('\(tabIdentifier)'): Exists: \(buttonById.exists) | Hittable: \(buttonById.isHittable)")
            print("  🔘 Button by Name ('\(tabName)'): Exists: \(buttonByName.exists) | Hittable: \(buttonByName.isHittable)")
            print("  🔧 Other by ID ('\(tabIdentifier)'): Exists: \(otherById.exists) | Hittable: \(otherById.isHittable)")
            print("  🔧 Other by Name ('\(tabName)'): Exists: \(otherByName.exists) | Hittable: \(otherByName.isHittable)")
            print("  📝 Text by Name ('\(tabName)'): Exists: \(textByName.exists) | Hittable: \(textByName.isHittable)")
            
            // Try predicate search
            let predicateButton = app.buttons.containing(NSPredicate(format: "label CONTAINS[c] %@", tabName)).firstMatch
            let predicateOther = app.otherElements.containing(NSPredicate(format: "label CONTAINS[c] %@", tabName)).firstMatch
            
            print("  🔍 Predicate Button: Exists: \(predicateButton.exists) | Hittable: \(predicateButton.isHittable)")
            print("  🔍 Predicate Other: Exists: \(predicateOther.exists) | Hittable: \(predicateOther.isHittable)")
        }
        
        print("====================================")
        
        // This test always passes - it's just for debugging
        XCTAssertTrue(true, "Tab search debug information printed")
    }
    
    func test_debug_attemptTabNavigation() throws {
        // Given - App is launched
        
        print("🔍 DEBUG: Attempting Tab Navigation")
        print("===================================")
        
        let tabNames = ["Home", "Search", "Library"]
        
        for tabName in tabNames {
            print("\n🎯 Attempting to navigate to \(tabName):")
            
            // Try our helper method
            let tabElement = findTabElement(tabName)
            print("  📍 findTabElement result: \(tabElement?.debugDescription ?? "nil")")
            
            if let tab = tabElement {
                print("  📋 Element details:")
                print("    - Label: '\(tab.label)'")
                print("    - Identifier: '\(tab.identifier)'")
                print("    - Exists: \(tab.exists)")
                print("    - Hittable: \(tab.isHittable)")
                print("    - Frame: \(tab.frame)")
                print("    - Element Type: \(tab.elementType.rawValue)")
                
                if tab.exists && tab.isHittable {
                    print("  ✅ Attempting tap...")
                    tab.tap()
                    
                    // Wait a moment and check result
                    sleep(1)
                    
                    // Check if navigation worked by looking for expected content
                    switch tabName {
                    case "Home":
                        let homeTitle = app.staticTexts["Thmanyah"]
                        print("  📊 Home navigation result: Title exists: \(homeTitle.exists)")
                    case "Search":
                        let searchField = findSearchField()
                        print("  📊 Search navigation result: Search field exists: \(searchField.exists)")
                    case "Library":
                        let libraryTitle = app.staticTexts["Library Tab"]
                        print("  📊 Library navigation result: Placeholder exists: \(libraryTitle.exists)")
                    default:
                        break
                    }
                } else {
                    print("  ❌ Element not tappable")
                }
            } else {
                print("  ❌ No tab element found")
            }
        }
        
        print("===================================")
        
        // This test always passes - it's just for debugging
        XCTAssertTrue(true, "Tab navigation debug completed")
    }
    
    func test_debug_inspectTabBarStructure() throws {
        // Given - App is launched
        
        print("🔍 DEBUG: Inspecting TabBar Structure")
        print("=====================================")
        
        // Look for any elements that might represent the tab bar
        print("🔍 Searching for TabBar container...")
        
        // Check for any elements with "tab" in their identifier or label
        let allElements = app.descendants(matching: .any)
        var tabRelatedElements: [XCUIElement] = []
        
        for element in allElements.allElementsBoundByIndex {
            if element.exists {
                let labelContainsTab = element.label.lowercased().contains("tab")
                let identifierContainsTab = element.identifier.lowercased().contains("tab")
                
                if labelContainsTab || identifierContainsTab {
                    tabRelatedElements.append(element)
                }
            }
        }
        
        print("📋 Found \(tabRelatedElements.count) tab-related elements:")
        for (index, element) in tabRelatedElements.enumerated() {
            print("  [\(index)] Type: \(element.elementType.rawValue) | Label: '\(element.label)' | ID: '\(element.identifier)' | Hittable: \(element.isHittable)")
        }
        
        // Look for elements at the bottom of the screen (where tab bar should be)
        print("\n🔍 Searching for bottom screen elements...")
        let screenHeight = app.frame.height
        let bottomThreshold = screenHeight * 0.8 // Bottom 20% of screen
        
        var bottomElements: [XCUIElement] = []
        for element in allElements.allElementsBoundByIndex {
            if element.exists && element.frame.minY > bottomThreshold {
                bottomElements.append(element)
            }
        }
        
        print("📋 Found \(bottomElements.count) elements in bottom 20% of screen:")
        for (index, element) in bottomElements.prefix(10).enumerated() { // Limit to first 10
            print("  [\(index)] Type: \(element.elementType.rawValue) | Label: '\(element.label)' | ID: '\(element.identifier)' | Y: \(element.frame.minY)")
        }
        
        print("=====================================")
        
        // This test always passes - it's just for debugging
        XCTAssertTrue(true, "TabBar structure inspection completed")
    }
}