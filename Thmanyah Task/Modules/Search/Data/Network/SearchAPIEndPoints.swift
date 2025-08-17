//
//  SearchAPIEndPoints.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation

struct SearchAPIEndPoints {
    
    static func search(word: String? = nil) -> Endpoint<SearchDTO> {
        var queryParameters: [String: String] = [:]
        
        if let word = word, !word.isEmpty {
            queryParameters["word"] = word
        }
        
        return Endpoint(
            path: "m1/735111-711675-default/search",
            method: .get,
            queryParameters: queryParameters
        )
    }
}
