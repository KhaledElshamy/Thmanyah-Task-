//
//  SearchDTO.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation

// MARK: - SearchDTO
struct SearchDTO: Codable {
    let sections: [SearchSectionDTO]?
}

// MARK: - SearchSectionDTO
struct SearchSectionDTO: Codable {
    let name: String?
    let type: String?
    let contentType: String?
    let order: String?
    let content: [SearchContentDTO]?
    
    enum CodingKeys: String, CodingKey {
        case name, type
        case contentType = "content_type"
        case order, content
    }
}

// MARK: - SearchContentDTO
struct SearchContentDTO: Codable {
    let podcastID: String
    let name: String
    let description: String
    let avatarURL: String
    let episodeCount: String
    let duration: String
    let language: String
    let priority: String
    let popularityScore: String
    let score: String
    
    enum CodingKeys: String, CodingKey {
        case podcastID = "podcast_id"
        case name, description
        case avatarURL = "avatar_url"
        case episodeCount = "episode_count"
        case duration, language, priority
        case popularityScore
        case score
    }
}



