//
//  SearchUseCasesTests.swift
//  Thmanyah TaskTests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest
@testable import Thmanyah_Task

@MainActor
final class SearchUseCasesTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: SearchUseCase!
    private var mockRepository: SearchRepositoryMock!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockRepository = SearchRepositoryMock()
        sut = SearchUseCase(searchRepository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    func test_search_whenRepositoryReturnsSuccess_shouldReturnResponse() async throws {
        // Given
        mockRepository.result = .success(createMockSearchResponse())
        
        // When
        let result = try await sut.search(query: "podcast")
        
        // Then
        XCTAssertEqual(mockRepository.searchCompletionCallsCount, 1)
        XCTAssertEqual(mockRepository.searchCalledWithQueries, ["podcast"])
        XCTAssertEqual(result.sections?.count, 1)
        XCTAssertEqual(result.sections?.first?.name, "Podcast Results")
        XCTAssertEqual(result.pagination?.nextPage, "2")
    }
    
    func test_search_whenCalledWithDifferentQueries_shouldPassCorrectQueryToRepository() async throws {
        // Given
        mockRepository.result = .success(createMockSearchResponse())
        
        // When
        _ = try await sut.search(query: "podcast")
        _ = try await sut.search(query: "audiobook")
        _ = try await sut.search(query: "article")
        
        // Then
        XCTAssertEqual(mockRepository.searchCompletionCallsCount, 3)
        XCTAssertEqual(mockRepository.searchCalledWithQueries, ["podcast", "audiobook", "article"])
    }
    
    func test_search_whenResponseHasMultipleSections_shouldReturnAllSections() async throws {
        // Given
        let response = createMockSearchResponseWithMultipleSections()
        mockRepository.result = .success(response)
        
        // When
        let result = try await sut.search(query: "test")
        
        // Then
        XCTAssertEqual(result.sections?.count, 3)
        XCTAssertEqual(result.sections?[0].name, "Podcast Results")
        XCTAssertEqual(result.sections?[1].name, "Book Results")
        XCTAssertEqual(result.sections?[2].name, "Article Results")
    }
    
    func test_search_whenResponseHasEmptySections_shouldReturnEmptyArray() async throws {
        // Given
        let response = SearchResponse(sections: [], pagination: nil)
        mockRepository.result = .success(response)
        
        // When
        let result = try await sut.search(query: "notfound")
        
        // Then
        XCTAssertEqual(result.sections?.count, 0)
        XCTAssertNil(result.pagination)
    }
    
    func test_search_whenResponseHasNilSections_shouldReturnNilSections() async throws {
        // Given
        let response = SearchResponse(sections: nil, pagination: nil)
        mockRepository.result = .success(response)
        
        // When
        let result = try await sut.search(query: "empty")
        
        // Then
        XCTAssertNil(result.sections)
        XCTAssertNil(result.pagination)
    }

    
    // MARK: - Error Tests
    func test_search_whenRepositoryThrowsNetworkError_shouldPropagateError() async {
        // Given
        mockRepository.result = .failure(SearchMockError.networkError)
        
        // When & Then
        do {
            _ = try await sut.search(query: "test")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? SearchMockError, SearchMockError.networkError)
            XCTAssertEqual(mockRepository.searchCompletionCallsCount, 0)
        }
    }
    
    func test_search_whenRepositoryThrowsDecodingError_shouldPropagateError() async {
        // Given
        mockRepository.result = .failure(SearchMockError.decodingError)
        
        // When & Then
        do {
            _ = try await sut.search(query: "test")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? SearchMockError, SearchMockError.decodingError)
        }
    }
    
    func test_search_whenRepositoryThrowsInvalidQuery_shouldPropagateError() async {
        // Given
        mockRepository.result = .failure(SearchMockError.invalidQuery)
        
        // When & Then
        do {
            _ = try await sut.search(query: "")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? SearchMockError, SearchMockError.invalidQuery)
        }
    }
    
    func test_search_whenRepositoryThrowsTimeout_shouldPropagateError() async {
        // Given
        mockRepository.result = .failure(SearchMockError.timeout)
        
        // When & Then
        do {
            _ = try await sut.search(query: "test")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? SearchMockError, SearchMockError.timeout)
        }
    }
    
    // MARK: - Edge Cases Tests
    func test_search_whenCalledWithEmptyQuery_shouldPassEmptyStringToRepository() async throws {
        // Given
        mockRepository.result = .success(createMockSearchResponse())
        
        // When
        _ = try await sut.search(query: "")
        
        // Then
        XCTAssertEqual(mockRepository.searchCalledWithQueries, [""])
    }
    
    func test_search_whenCalledWithWhitespaceQuery_shouldPassWhitespaceToRepository() async throws {
        // Given
        mockRepository.result = .success(createMockSearchResponse())
        
        // When
        _ = try await sut.search(query: "   ")
        
        // Then
        XCTAssertEqual(mockRepository.searchCalledWithQueries, ["   "])
    }
    
    func test_search_whenCalledWithSpecialCharacters_shouldPassSpecialCharactersToRepository() async throws {
        // Given
        mockRepository.result = .success(createMockSearchResponse())
        
        // When
        _ = try await sut.search(query: "test@#$%")
        
        // Then
        XCTAssertEqual(mockRepository.searchCalledWithQueries, ["test@#$%"])
    }
    
    // MARK: - Concurrent Tests
    func test_search_whenCalledConcurrently_shouldHandleMultipleRequests() async throws {
        // Given
        mockRepository.result = .success(createMockSearchResponse())
        
        // When
        async let result1 = sut.search(query: "query1")
        async let result2 = sut.search(query: "query2")
        async let result3 = sut.search(query: "query3")
        
        let results = try await [result1, result2, result3]
        
        // Then
        XCTAssertEqual(results.count, 3)
        XCTAssertEqual(mockRepository.searchCompletionCallsCount, 3)
        XCTAssertEqual(Set(mockRepository.searchCalledWithQueries), Set(["query1", "query2", "query3"]))
    }
    
    // MARK: - Test Helper Methods
    private func createMockSearchResponse() -> SearchResponse {
        let content = SearchContent(
            podcastID: "podcast1",
            name: "Test Podcast",
            description: "Test Description",
            avatarURL: "https://example.com/avatar.jpg",
            episodeCount: "10",
            duration: "3600",
            language: "en",
            priority: "1",
            popularityScore: "100",
            score: "4.5"
        )
        
        let section = SearchSection(
            id: "section1",
            name: "Podcast Results",
            type: .square,
            contentType: .podcast,
            order: 1,
            content: [content]
        )
        
        let pagination = SearchPagination(
            nextPage: "2",
            totalPages: 5
        )
        
        return SearchResponse(
            sections: [section],
            pagination: pagination
        )
    }
    
    private func createMockSearchResponseWithMultipleSections() -> SearchResponse {
        let podcastContent = SearchContent(
            podcastID: "podcast1",
            name: "Test Podcast",
            description: "Test Podcast Description",
            avatarURL: "https://example.com/podcast.jpg",
            episodeCount: "15",
            duration: "3600",
            language: "en",
            priority: "1",
            popularityScore: "95",
            score: "4.8"
        )
        
        let bookContent = SearchContent(
            podcastID: nil,
            name: "Test Book",
            description: "Test Book Description",
            avatarURL: "https://example.com/book.jpg",
            episodeCount: nil,
            duration: "7200",
            language: "en",
            priority: "2",
            popularityScore: "87",
            score: "4.6"
        )
        
        let articleContent = SearchContent(
            podcastID: nil,
            name: "Test Article",
            description: "Test Article Description",
            avatarURL: "https://example.com/article.jpg",
            episodeCount: nil,
            duration: "1800",
            language: "en",
            priority: "3",
            popularityScore: "72",
            score: "4.2"
        )
        
        let podcastSection = SearchSection(
            id: "section1",
            name: "Podcast Results",
            type: .square,
            contentType: .podcast,
            order: 1,
            content: [podcastContent]
        )
        
        let bookSection = SearchSection(
            id: "section2",
            name: "Book Results",
            type: .bigSquare,
            contentType: .audioBook,
            order: 2,
            content: [bookContent]
        )
        
        let articleSection = SearchSection(
            id: "section3",
            name: "Article Results",
            type: .twoLinesGrid,
            contentType: .audioArticle,
            order: 3,
            content: [articleContent]
        )
        
        let pagination = SearchPagination(
            nextPage: "2",
            totalPages: 10
        )
        
        return SearchResponse(
            sections: [podcastSection, bookSection, articleSection],
            pagination: pagination
        )
    }
}
