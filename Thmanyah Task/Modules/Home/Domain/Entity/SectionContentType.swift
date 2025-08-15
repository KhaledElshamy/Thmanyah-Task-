//
//  HomeContentType.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

enum SectionContentType: String {
    case podcast
    case episode
    case audioBook = "audio_book"
    case audioArticle = "audio_article"
    case unknown
    
    init(from rawValue: String?) {
        guard let value = rawValue?.lowercased().replacingOccurrences(of: "_", with: "") else {
            self = .unknown
            return
        }
        
        switch value {
        case "podcast":
            self = .podcast
        case "episode":
            self = .episode
        case "audiobook":
            self = .audioBook
        case "audioarticle":
            self = .audioArticle
        default:
            self = .unknown
        }
    }
}
