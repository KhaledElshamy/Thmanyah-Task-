//
//  ContentItemViewModel.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

struct ContentItemViewModel: Identifiable {
    let id: String
    let content: SectionContent
    
    init(content: SectionContent) {
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
        return content.authorName
    }
    
    var imageURL: String? {
        return content.avatarURL
    }
    
    var duration: String? {
        return content.duration
    }
    
    var score: Double? {
        return content.score
    }
    
    var releaseDate: Date? {
        return content.releaseDate
    }
    
    var formattedScore: String? {
        guard let score = score else { return nil }
        return String(format: "%.1f", score)
    }
    
    var formattedReleaseDate: String? {
        guard let releaseDate = releaseDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: releaseDate)
    }
    
    // Content type specific properties
    var isPodcast: Bool {
        return content.podcastID != nil
    }
    
    var isEpisode: Bool {
        return content.episodeID != nil
    }
    
    var isAudiobook: Bool {
        return content.audiobookID != nil
    }
    
    var isAudioArticle: Bool {
        return content.articleID != nil
    }
    
    // Determines if this content should show release date instead of menu actions
    var shouldShowReleaseDateInsteadOfMenu: Bool {
        return isEpisode || isAudioArticle
    }
}
