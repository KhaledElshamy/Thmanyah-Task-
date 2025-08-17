//
//  HomeUseCasesTests.swift
//  Thmanyah TaskTests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest
@testable import Thmanyah_Task

final class HomeUseCasesTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: HomeUseCase!
    private var mockRepository: HomeRepositoryMock!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockRepository = HomeRepositoryMock()
        sut = HomeUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    func test_fetchHome_whenRepositoryReturnsSuccess_shouldReturnResponse() async throws {
        // Given
        mockRepository.result = .success(createMockHomeResponse())
        
        // When
        let result = try await sut.fetchHome(page: 1)
        
        // Then
        XCTAssertEqual(mockRepository.fetchCompletionCallsCount, 1)
        XCTAssertEqual(mockRepository.fetchCalledWithPages, [1])
        XCTAssertEqual(result.sections?.count, 1)
        XCTAssertEqual(result.sections?.first?.name, "Featured Podcasts")
        XCTAssertEqual(result.pagination?.nextPage, "2")
    }
//    
    func test_fetchHome_whenCalledWithDifferentPages_shouldPassCorrectPageToRepository() async throws {
        // Given
        mockRepository.result = .success(createMockHomeResponse())
        
        // When
        _ = try await sut.fetchHome(page: 1)
        _ = try await sut.fetchHome(page: 2)
        _ = try await sut.fetchHome(page: 3)
        
        // Then
        XCTAssertEqual(mockRepository.fetchCompletionCallsCount, 3)
        XCTAssertEqual(mockRepository.fetchCalledWithPages, [1, 2, 3])
    }
    
    func test_fetchHome_whenResponseHasMultipleSections_shouldReturnAllSections() async throws {
        // Given
        let response = createMockHomeResponseWithMultipleSections()
        mockRepository.result = .success(response)
        
        // When
        let result = try await sut.fetchHome(page: 1)
        
        // Then
        XCTAssertEqual(result.sections?.count, 3)
        XCTAssertEqual(result.sections?[0].name, "Featured Podcasts")
        XCTAssertEqual(result.sections?[1].name, "Popular Books")
        XCTAssertEqual(result.sections?[2].name, "Recent Articles")
    }
    
    func test_fetchHome_whenResponseHasEmptySections_shouldReturnEmptyArray() async throws {
        // Given
        let response = HomeResponse(sections: [], pagination: nil)
        mockRepository.result = .success(response)
        
        // When
        let result = try await sut.fetchHome(page: 1)
        
        // Then
        XCTAssertEqual(result.sections?.count, 0)
        XCTAssertNil(result.pagination)
    }
    
    func test_fetchHome_whenResponseHasNilSections_shouldReturnNilSections() async throws {
        // Given
        let response = HomeResponse(sections: nil, pagination: nil)
        mockRepository.result = .success(response)
        
        // When
        let result = try await sut.fetchHome(page: 1)
        
        // Then
        XCTAssertNil(result.sections)
        XCTAssertNil(result.pagination)
    }

    
//    // MARK: - Error Tests
    func test_fetchHome_whenRepositoryThrowsNetworkError_shouldPropagateError() async {
        // Given
        mockRepository.result = .failure(MockError.networkError)
        
        // When & Then
        do {
            _ = try await sut.fetchHome(page: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? MockError, MockError.networkError)
            XCTAssertEqual(mockRepository.fetchCompletionCallsCount, 0)
        }
    }
    
    func test_fetchHome_whenRepositoryThrowsDecodingError_shouldPropagateError() async {
        // Given
        mockRepository.result = .failure(MockError.decodingError)
        
        // When & Then
        do {
            _ = try await sut.fetchHome(page: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? MockError, MockError.decodingError)
        }
    }
    
    func test_fetchHome_whenRepositoryThrowsTimeout_shouldPropagateError() async {
        // Given
        mockRepository.result = .failure(MockError.timeout)
        
        // When & Then
        do {
            _ = try await sut.fetchHome(page: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? MockError, MockError.timeout)
        }
    }
    
    func test_fetchHome_whenRepositoryThrowsInvalidResponse_shouldPropagateError() async {
        // Given
        mockRepository.result = .failure(MockError.invalidResponse)
        
        // When & Then
        do {
            _ = try await sut.fetchHome(page: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? MockError, MockError.invalidResponse)
        }
    }
    
    // MARK: - Concurrent Tests
    func test_fetchHome_whenCalledConcurrently_shouldHandleMultipleRequests() async throws {
        // Given
        mockRepository.result = .success(createMockHomeResponse())
        
        // When
        async let result1 = sut.fetchHome(page: 1)
        async let result2 = sut.fetchHome(page: 2)
        async let result3 = sut.fetchHome(page: 3)
        
        let results = try await [result1, result2, result3]
        
        // Then
        XCTAssertEqual(results.count, 3)
        XCTAssertEqual(mockRepository.fetchCompletionCallsCount, 3)
        XCTAssertEqual(Set(mockRepository.fetchCalledWithPages), Set([1, 2, 3]))
    }
    
    // MARK: - Test Helper Methods
    private func createMockHomeResponse() -> HomeResponse {
        let content = SectionContent(
            podcastID: "podcast1",
            episodeID: "episode1",
            audiobookID: nil,
            articleID: nil,
            name: "Test Podcast",
            description: "Test Description",
            avatarURL: "https://example.com/avatar.jpg",
            duration: "3600",
            authorName: "Test Author",
            score: 4.5,
            releaseDate: Date(),
            audioURL: "https://example.com/audio.mp3"
        )
        
        let section = HomeSections(
            name: "Featured Podcasts",
            type: .square,
            contentType: .podcast,
            order: 1,
            content: [content]
        )
        
        let pagination = HomePagination(
            nextPage: "2",
            totalPages: 5
        )
        
        return HomeResponse(
            sections: [section],
            pagination: pagination
        )
    }
    
    private func createMockHomeResponseWithMultipleSections() -> HomeResponse {
        let podcastContent = SectionContent(
            podcastID: "podcast1",
            episodeID: "episode1",
            audiobookID: nil,
            articleID: nil,
            name: "Test Podcast",
            description: "Test Podcast Description",
            avatarURL: "https://example.com/podcast.jpg",
            duration: "3600",
            authorName: "Podcast Author",
            score: 4.8,
            releaseDate: Date(),
            audioURL: "https://example.com/podcast.mp3"
        )
        
        let bookContent = SectionContent(
            podcastID: nil,
            episodeID: nil,
            audiobookID: "book1",
            articleID: nil,
            name: "Test Book",
            description: "Test Book Description",
            avatarURL: "https://example.com/book.jpg",
            duration: "7200",
            authorName: "Book Author",
            score: 4.6,
            releaseDate: Date(),
            audioURL: "https://example.com/book.mp3"
        )
        
        let articleContent = SectionContent(
            podcastID: nil,
            episodeID: nil,
            audiobookID: nil,
            articleID: "article1",
            name: "Test Article",
            description: "Test Article Description",
            avatarURL: "https://example.com/article.jpg",
            duration: "1800",
            authorName: "Article Author",
            score: 4.2,
            releaseDate: Date(),
            audioURL: "https://example.com/article.mp3"
        )
        
        let podcastSection = HomeSections(
            name: "Featured Podcasts",
            type: .square,
            contentType: .podcast,
            order: 1,
            content: [podcastContent]
        )
        
        let bookSection = HomeSections(
            name: "Popular Books",
            type: .bigSquare,
            contentType: .audioBook,
            order: 2,
            content: [bookContent]
        )
        
        let articleSection = HomeSections(
            name: "Recent Articles",
            type: .twoLinesGrid,
            contentType: .audioArticle,
            order: 3,
            content: [articleContent]
        )
        
        let pagination = HomePagination(
            nextPage: "2",
            totalPages: 10
        )
        
        return HomeResponse(
            sections: [podcastSection, bookSection, articleSection],
            pagination: pagination
        )
    }
}
