//
//  SectionContent.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

struct SectionContent:Identifiable {
    let id = UUID().uuidString
    let podcastID: String?
    let episodeID: String?
    let audiobookID: String?
    let articleID: String?
    let name: String
    let description: String?
    let avatarURL: String?
    let duration: String?
    let authorName: String?
    let score: Double?
    let releaseDate: Date?
    let audioURL: String?
}

