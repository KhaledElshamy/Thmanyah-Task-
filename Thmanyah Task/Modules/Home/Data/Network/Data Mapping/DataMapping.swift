//
//  DataMapping.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

// Mapping to Domain
extension HomeResponseDTO {
    func toDomain() -> HomeResponse {
        return .init(sections: sections?.compactMap { $0.toDomain() } ?? [],
                     pagination: pagination?.toDomain())
    }
}

extension HomePaginationDTO {
    func toDomain() -> HomePagination {
        .init(
            nextPage: nextPage,
            totalPages: totalPages ?? 0
        )
    }
}


extension HomeResponseDTO.HomeSectionDTO {
    func toDomain() -> HomeSections {
        return .init(
            name: name ?? "",
            type: SectionType(from: type),
            contentType: SectionContentType(from: contentType),
            order: order ?? 0,
            content: content?.compactMap { $0.toDomain() } ?? []
        )
    }
}


extension HomeResponseDTO.HomeSectionDTO.HomeSectionContentDTO {
    func toDomain() -> SectionContent {
        return .init(
            podcastID: podcastID,
            episodeID: episodeID,
            audiobookID: audiobookID,
            articleID: articleID,
            name: name ?? podcastName ?? "",
            description: description,
            avatarURL: avatarURL,
            duration: duration?.asHoursAndMinutes,
            authorName: authorName,
            score: score,
            releaseDate: dateFormatter.date(from: releaseDate ?? ""),
            audioURL: audioURL ?? separatedAudioURL ?? paidEarlyAccessAudioURL
        )
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy" // day first
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
