//
//  TextCleaningHelperTests.swift
//  Thmanyah TaskTests
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import XCTest
@testable import Thmanyah_Task

final class TextCleaningHelperTests: XCTestCase {
    
    func testCleanText_WithHTMLTags_RemovesTags() {
        // Given
        let input = "This is a <a href='link'>sample</a> text"
        
        // When
        let result = TextCleaningHelper.cleanText(input)
        
        // Then
        XCTAssertEqual(result, "This is a sample text")
    }
    
    func testCleanText_WithClosingTags_RemovesTags() {
        // Given
        let input = "Sample text</a> with closing tag"
        
        // When
        let result = TextCleaningHelper.cleanText(input)
        
        // Then
        XCTAssertEqual(result, "Sample text with closing tag")
    }
    
    func testCleanText_WithHTMLEntities_RemovesEntities() {
        // Given
        let input = "Text with&nbsp;entities&amp;more"
        
        // When
        let result = TextCleaningHelper.cleanText(input)
        
        // Then
        XCTAssertEqual(result, "Text with entities more")
    }
    
    func testCleanText_WithMultipleSpaces_CleansSpaces() {
        // Given
        let input = "Text  with   multiple    spaces"
        
        // When
        let result = TextCleaningHelper.cleanText(input)
        
        // Then
        XCTAssertEqual(result, "Text with multiple spaces")
    }
    
    func testCleanText_WithNilInput_ReturnsNil() {
        // Given
        let input: String? = nil
        
        // When
        let result = TextCleaningHelper.cleanText(input)
        
        // Then
        XCTAssertNil(result)
    }
    
    func testCleanText_WithEmptyString_ReturnsNil() {
        // Given
        let input = ""
        
        // When
        let result = TextCleaningHelper.cleanText(input)
        
        // Then
        XCTAssertNil(result)
    }
    
    func testCleanText_WithOnlyHTMLTags_ReturnsNil() {
        // Given
        let input = "<div></div>"
        
        // When
        let result = TextCleaningHelper.cleanText(input)
        
        // Then
        XCTAssertNil(result)
    }
    
    func testCleanText_WithComplexHTML_CleansCorrectly() {
        // Given
        let input = "<p>This is a <strong>bold</strong> text with <br/> line break</p>"
        
        // When
        let result = TextCleaningHelper.cleanText(input)
        
        // Then
        XCTAssertEqual(result, "This is a bold text with line break")
    }
    
    func testStringExtension_CleanedFromHTML() {
        // Given
        let input = "Text with <b>HTML</b> tags"
        
        // When
        let result = input.cleanedFromHTML
        
        // Then
        XCTAssertEqual(result, "Text with HTML tags")
    }
}
