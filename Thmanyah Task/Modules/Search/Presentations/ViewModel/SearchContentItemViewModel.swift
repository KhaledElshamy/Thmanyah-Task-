//
//  SearchContentItemViewModel.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation

struct SearchContentItemViewModel: Identifiable {
    let id: String
    let content: SearchContent
    
    init(content: SearchContent) {
        self.id = content.id
        self.content = content
    }
    
    var title: String {
        return TextCleaningHelper.cleanText(content.name) ?? content.name
    }
    
    var subtitle: String? {
        return TextCleaningHelper.cleanText(content.description)
    }
    
    var authorName: String? {
        return nil // SearchContent doesn't have authorName
    }
    
    var score: Double? {
        return Double(content.score ?? "")
    }
    
    var duration: String? {
        return content.duration
    }
    
    var episodeCount: String? {
        return content.episodeCount
    }
    
    var avatarURL: String? {
        return content.avatarURL
    }
    
    var language: String? {
        return content.language
    }
    
    var priority: String? {
        return content.priority
    }
    
    var popularityScore: String? {
        return content.popularityScore
    }
    
    // MARK: - Computed Properties for UI
    var isAudiobook: Bool {
        return content.podcastID != nil
    }
    
    var isAudioArticle: Bool {
        return false // Add logic based on your content identification
    }
    
    var shouldShowReleaseDateInsteadOfMenu: Bool {
        return false // Add logic based on your content type
    }
}
