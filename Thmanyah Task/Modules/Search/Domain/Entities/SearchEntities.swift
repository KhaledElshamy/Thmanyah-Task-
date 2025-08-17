//
//  SearchEntities.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation

// MARK: - Search Response
struct SearchResponse {
    let sections: [SearchSection]?
    let pagination: SearchPagination?
}

// MARK: - Search Section
struct SearchSection {
    let id: String
    let name: String?
    let type: SectionType?
    let contentType: SectionContentType?
    let order: Int?
    let content: [SearchContent]?
}

// MARK: - Search Content
struct SearchContent: Identifiable {
    let id = UUID().uuidString
    let podcastID: String?
    let name: String
    let description: String?
    let avatarURL: String?
    let episodeCount: String?
    let duration: String?
    let language: String?
    let priority: String?
    let popularityScore: String?
    let score: String?
}

// MARK: - Search Pagination
struct SearchPagination {
    let nextPage: String?
    let totalPages: Int?
}