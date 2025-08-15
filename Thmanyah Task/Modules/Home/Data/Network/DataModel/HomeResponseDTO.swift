//
//  HomeSectionsResponseDTO.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

struct HomeResponseDTO: Codable {
    var sections: [HomeSectionDTO]?
    var pagination: HomePaginationDTO?
}

extension HomeResponseDTO {
    struct HomeSectionDTO: Codable {
        var name: String?
        var type: String?
        var contentType: String?
        var order: Int?
        var content: [HomeSectionContentDTO]?

        enum CodingKeys: String, CodingKey {
            case name, type
            case contentType = "content_type"
            case order, content
        }
    }
}

extension HomeResponseDTO.HomeSectionDTO {
    struct HomeSectionContentDTO: Codable {
        var podcastID: String?
        var name: String?
        var description: String?
        var avatarURL: String?
        var episodeCount: Int?
        var duration: Int?
        var language: String?
        var priority: Int?
        var popularityScore: Int?
        var score: Double?
        var podcastPopularityScore: Int?
        var podcastPriority: Int?
        var episodeID: String?
        var seasonNumber: Int?
        var episodeType: String?
        var podcastName: String?
        var authorName: String?
        var number: Int?
        var separatedAudioURL: String?
        var audioURL: String?
        var releaseDate: String?
        var chapters: [String]?
        var paidIsEarlyAccess: Bool?
        var paidIsNowEarlyAccess: Bool?
        var paidIsExclusive: Bool?
        var paidTranscriptURL: String?
        var freeTranscriptURL: String?
        var paidIsExclusivePartially: Bool?
        var paidExclusiveStartTime: Int?
        var paidEarlyAccessDate: String?
        var paidEarlyAccessAudioURL: String?
        var paidExclusivityType: String?
        var audiobookID: String?
        var articleID: String?

        enum CodingKeys: String, CodingKey {
            case podcastID = "podcast_id"
            case name
            case description
            case avatarURL = "avatar_url"
            case episodeCount = "episode_count"
            case duration
            case language
            case priority
            case popularityScore
            case score
            case podcastPopularityScore
            case podcastPriority
            case episodeID = "episode_id"
            case seasonNumber = "season_number"
            case episodeType = "episode_type"
            case podcastName = "podcast_name"
            case authorName = "author_name"
            case number
            case separatedAudioURL = "separated_audio_url"
            case audioURL = "audio_url"
            case releaseDate = "release_date"
            case chapters
            case paidIsEarlyAccess = "paid_is_early_access"
            case paidIsNowEarlyAccess = "paid_is_now_early_access"
            case paidIsExclusive = "paid_is_exclusive"
            case paidTranscriptURL = "paid_transcript_url"
            case freeTranscriptURL = "free_transcript_url"
            case paidIsExclusivePartially = "paid_is_exclusive_partially"
            case paidExclusiveStartTime = "paid_exclusive_start_time"
            case paidEarlyAccessDate = "paid_early_access_date"
            case paidEarlyAccessAudioURL = "paid_early_access_audio_url"
            case paidExclusivityType = "paid_exclusivity_type"
            case audiobookID = "audiobook_id"
            case articleID = "article_id"
        }
    }
}
