//
//  SearchDataMapping.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation

// MARK: - SearchDTO Mapping
extension SearchDTO {
    func toDomain() -> SearchResponse {
        return SearchResponse(
            sections: sections?.compactMap { $0.toDomain() },
            pagination: nil
        )
    }
}

// MARK: - SearchSectionDTO Mapping
extension SearchSectionDTO {
    func toDomain() -> SearchSection {
        return SearchSection(
            name: name,
            type: SectionType(rawValue: type ?? ""),
            contentType: SectionContentType(rawValue: contentType ?? ""),
            order: Int(order ?? "0"),
            content: content?.compactMap { $0.toDomain() }
        )
    }
}

// MARK: - SearchContentDTO Mapping
extension SearchContentDTO {
    func toDomain() -> SearchContent {
        return SearchContent(
            podcastID: podcastID,
            name: name,
            description: description,
            avatarURL: avatarURL,
            episodeCount: episodeCount,
            duration: duration,
            language: language,
            priority: priority,
            popularityScore: popularityScore,
            score: score
        )
    }
}


