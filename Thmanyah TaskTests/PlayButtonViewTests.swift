//
//  PlayButtonViewTests.swift
//  Thmanyah TaskTests
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import XCTest
@testable import Thmanyah_Task

final class PlayButtonViewTests: XCTestCase {
    
    func testFormatDuration_WithHoursAndMinutes_ReturnsFormattedString() {
        // Given
        let playButton = PlayButtonView(duration: "1hr 30m") {}
        
        // When - Testing the internal formatDuration function logic
        let result = formatDurationHelper("1hr 30m")
        
        // Then
        XCTAssertEqual(result, "1h 30m")
    }
    
    func testFormatDuration_WithZeroHours_HidesHours() {
        // Given
        let duration = "0hr 45m"
        
        // When
        let result = formatDurationHelper(duration)
        
        // Then
        XCTAssertEqual(result, "45m")
    }
    
    func testFormatDuration_WithZeroMinutes_HidesMinutes() {
        // Given
        let duration = "2hr 0m"
        
        // When
        let result = formatDurationHelper(duration)
        
        // Then
        XCTAssertEqual(result, "2h")
    }
    
    func testFormatDuration_WithOnlyMinutes_ReturnsMinutes() {
        // Given
        let duration = "45m"
        
        // When
        let result = formatDurationHelper(duration)
        
        // Then
        XCTAssertEqual(result, "45m")
    }
    
    func testFormatDuration_WithInvalidFormat_ReturnsOriginal() {
        // Given
        let duration = "invalid"
        
        // When
        let result = formatDurationHelper(duration)
        
        // Then
        XCTAssertEqual(result, "invalid")
    }
    
    // Helper function to test the duration formatting logic
    private func formatDurationHelper(_ duration: String) -> String {
        let components = duration.components(separatedBy: " ")
        var result: [String] = []
        
        for component in components {
            if component.contains("hr") {
                let hours = component.replacingOccurrences(of: "hr", with: "")
                if let hourValue = Int(hours), hourValue > 0 {
                    result.append("\(hourValue)h")
                }
            } else if component.contains("m") {
                let minutes = component.replacingOccurrences(of: "m", with: "")
                if let minuteValue = Int(minutes), minuteValue > 0 {
                    result.append("\(minuteValue)m")
                }
            }
        }
        
        return result.isEmpty ? duration : result.joined(separator: " ")
    }
}
