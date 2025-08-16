//
//  TextCleaningHelper.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

struct TextCleaningHelper {
    
    /// Removes HTML tags and entities from text
    static func cleanText(_ text: String?) -> String? {
        guard let text = text else { return nil }
        
        var cleanedText = text
        
        // Remove HTML tags like </a>, <br>, <p>, etc.
        cleanedText = cleanedText.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )
        
        // Remove HTML entities like &nbsp;, &amp;, etc.
        cleanedText = cleanedText.replacingOccurrences(
            of: "&[a-zA-Z0-9#]+;",
            with: " ",
            options: .regularExpression
        )
        
        // Clean up multiple spaces
        cleanedText = cleanedText.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression
        )
        
        // Trim whitespace
        cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return cleanedText.isEmpty ? nil : cleanedText
    }
}

// MARK: - String Extension for convenience
extension String {
    var cleanedFromHTML: String {
        return TextCleaningHelper.cleanText(self) ?? self
    }
}
