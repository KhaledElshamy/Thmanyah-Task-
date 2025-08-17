//
//  ContentItemViewModelTests.swift
//  Thmanyah TaskTests
//
//  Created by Khaled Elshamy on 25/06/2025.
//

import XCTest
@testable import Thmanyah_Task

final class ContentItemViewModelTests: XCTestCase {
    
    func testShouldShowReleaseDateInsteadOfMenu_WithEpisode_ReturnsTrue() {
        // Given
        let sectionContent = SectionContent(
            podcastID: nil,
            episodeID: "episode123",
            audiobookID: nil,
            articleID: nil,
            name: "Test Episode",
            description: nil,
            avatarURL: nil,
            duration: nil,
            authorName: nil,
            score: nil,
            releaseDate: nil,
            audioURL: nil
        )
        let viewModel = ContentItemViewModel(content: sectionContent)
        
        // When
        let result = viewModel.shouldShowReleaseDateInsteadOfMenu
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testShouldShowReleaseDateInsteadOfMenu_WithAudioArticle_ReturnsTrue() {
        // Given
        let sectionContent = SectionContent(
            podcastID: nil,
            episodeID: nil,
            audiobookID: nil,
            articleID: "article123",
            name: "Test Article",
            description: nil,
            avatarURL: nil,
            duration: nil,
            authorName: nil,
            score: nil,
            releaseDate: nil,
            audioURL: nil
        )
        let viewModel = ContentItemViewModel(content: sectionContent)
        
        // When
        let result = viewModel.shouldShowReleaseDateInsteadOfMenu
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testShouldShowReleaseDateInsteadOfMenu_WithPodcast_ReturnsFalse() {
        // Given
        let sectionContent = SectionContent(
            podcastID: "podcast123",
            episodeID: nil,
            audiobookID: nil,
            articleID: nil,
            name: "Test Podcast",
            description: nil,
            avatarURL: nil,
            duration: nil,
            authorName: nil,
            score: nil,
            releaseDate: nil,
            audioURL: nil
        )
        let viewModel = ContentItemViewModel(content: sectionContent)
        
        // When
        let result = viewModel.shouldShowReleaseDateInsteadOfMenu
        
        // Then
        XCTAssertFalse(result)
    }
    
    func testShouldShowReleaseDateInsteadOfMenu_WithAudiobook_ReturnsFalse() {
        // Given
        let sectionContent = SectionContent(
            podcastID: nil,
            episodeID: nil,
            audiobookID: "audiobook123",
            articleID: nil,
            name: "Test Audiobook",
            description: nil,
            avatarURL: nil,
            duration: nil,
            authorName: nil,
            score: nil,
            releaseDate: nil,
            audioURL: nil
        )
        let viewModel = ContentItemViewModel(content: sectionContent)
        
        // When
        let result = viewModel.shouldShowReleaseDateInsteadOfMenu
        
        // Then
        XCTAssertFalse(result)
    }
    
    func testContentTypeFlags_CorrectlyIdentifyTypes() {
        // Given
        let episodeContent = SectionContent(
            podcastID: nil, episodeID: "ep123", audiobookID: nil, articleID: nil,
            name: "Episode", description: nil, avatarURL: nil, duration: nil,
            authorName: nil, score: nil, releaseDate: nil, audioURL: nil
        )
        let episodeViewModel = ContentItemViewModel(content: episodeContent)
        
        // Then
        XCTAssertTrue(episodeViewModel.isEpisode)
        XCTAssertFalse(episodeViewModel.isPodcast)
        XCTAssertFalse(episodeViewModel.isAudiobook)
        XCTAssertFalse(episodeViewModel.isAudioArticle)
    }
}
