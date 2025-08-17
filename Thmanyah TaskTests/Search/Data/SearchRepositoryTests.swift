//
//  SearchRepositoryTests.swift
//  Thmanyah TaskTests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest
@testable import Thmanyah_Task

@MainActor
final class SearchRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: SearchRepository!
    private var mockDataTransferService: DataTransferServiceMock!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockDataTransferService = DataTransferServiceMock()
        sut = SearchRepository(dataTransferService: mockDataTransferService)
    }
    
    override func tearDown() {
        sut = nil
        mockDataTransferService = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    func test_search_whenDataTransferServiceReturnsSuccess_shouldReturnSearchResponse() async throws {
        // Given
        let mockDTO = createMockSearchDTO()
        mockDataTransferService.result = .success(mockDTO)
        
        // When
        let result = try await sut.search(query: "podcast")
        
        // Then
        XCTAssertEqual(mockDataTransferService.requestCallsCount, 1)
        XCTAssertEqual(mockDataTransferService.requestCalledWithEndpoints, ["m1/735111-711675-default/search"])
        XCTAssertEqual(result.sections?.count, 1)
        XCTAssertEqual(result.sections?.first?.name, "Test Section")
    }
    
    func test_search_whenCalledWithNonEmptyQuery_shouldPassWordParameter() async throws {
        // Given
        let mockDTO = createMockSearchDTO()
        mockDataTransferService.result = .success(mockDTO)
        
        // When
        _ = try await sut.search(query: "podcast")
        
        // Then
        XCTAssertEqual(mockDataTransferService.requestCallsCount, 1)
        // The endpoint should include the word parameter
        XCTAssertEqual(mockDataTransferService.requestCalledWithEndpoints, ["m1/735111-711675-default/search"])
    }
    
    func test_search_whenCalledWithEmptyQuery_shouldNotPassWordParameter() async throws {
        // Given
        let mockDTO = createMockSearchDTO()
        mockDataTransferService.result = .success(mockDTO)
        
        // When
        _ = try await sut.search(query: "")
        
        // Then
        XCTAssertEqual(mockDataTransferService.requestCallsCount, 1)
        XCTAssertEqual(mockDataTransferService.requestCalledWithEndpoints, ["m1/735111-711675-default/search"])
    }
    
    func test_search_whenCalledWithWhitespaceQuery_shouldNotPassWordParameter() async throws {
        // Given
        let mockDTO = createMockSearchDTO()
        mockDataTransferService.result = .success(mockDTO)
        
        // When
        _ = try await sut.search(query: "   ")
        
        // Then
        XCTAssertEqual(mockDataTransferService.requestCallsCount, 1)
        XCTAssertEqual(mockDataTransferService.requestCalledWithEndpoints, ["m1/735111-711675-default/search"])
    }
    
    func test_search_whenCalledWithMultipleDifferentQueries_shouldMakeMultipleRequests() async throws {
        // Given
        let mockDTO = createMockSearchDTO()
        mockDataTransferService.result = .success(mockDTO)
        
        // When
        _ = try await sut.search(query: "podcast")
        _ = try await sut.search(query: "audiobook")
        _ = try await sut.search(query: "article")
        
        // Then
        XCTAssertEqual(mockDataTransferService.requestCallsCount, 3)
        XCTAssertEqual(mockDataTransferService.requestCalledWithEndpoints.count, 3)
    }
    
    func test_search_whenResponseHasMultipleSections_shouldReturnAllSections() async throws {
        // Given
        let mockDTO = createMockSearchDTOWithMultipleSections()
        mockDataTransferService.result = .success(mockDTO)
        
        // When
        let result = try await sut.search(query: "test")
        
        // Then
        XCTAssertEqual(result.sections?.count, 2)
        XCTAssertEqual(result.sections?[0].name, "Podcast Section")
        XCTAssertEqual(result.sections?[1].name, "Book Section")
    }
    
    func test_search_whenResponseHasEmptySections_shouldReturnEmptyArray() async throws {
        // Given
        let mockDTO = SearchDTO(sections: [])
        mockDataTransferService.result = .success(mockDTO)
        
        // When
        let result = try await sut.search(query: "notfound")
        
        // Then
        XCTAssertEqual(result.sections?.count, 0)
    }
    
    func test_search_whenResponseHasNilSections_shouldReturnNilSections() async throws {
        // Given
        let mockDTO = SearchDTO(sections: nil)
        mockDataTransferService.result = .success(mockDTO)
        
        // When
        let result = try await sut.search(query: "empty")
        
        // Then
        XCTAssertNil(result.sections)
    }
    
    // MARK: - Error Tests
    func test_search_whenDataTransferServiceThrowsNetworkError_shouldPropagateError() async {
        // Given
        mockDataTransferService.result = .failure(DataTransferMockError.networkError)
        
        // When & Then
        do {
            _ = try await sut.search(query: "test")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? DataTransferMockError, DataTransferMockError.networkError)
            XCTAssertEqual(mockDataTransferService.requestCallsCount, 1)
        }
    }
    
    func test_search_whenDataTransferServiceThrowsDecodingError_shouldPropagateError() async {
        // Given
        mockDataTransferService.result = .failure(DataTransferMockError.decodingError)
        
        // When & Then
        do {
            _ = try await sut.search(query: "test")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? DataTransferMockError, DataTransferMockError.decodingError)
        }
    }
    
    func test_search_whenDataTransferServiceThrowsTypeMismatch_shouldPropagateError() async {
        // Given
        mockDataTransferService.result = .failure(DataTransferMockError.typeMismatch)
        
        // When & Then
        do {
            _ = try await sut.search(query: "test")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? DataTransferMockError, DataTransferMockError.typeMismatch)
        }
    }
    
    // MARK: - Edge Cases Tests
    func test_search_whenCalledWithSpecialCharacters_shouldHandleGracefully() async throws {
        // Given
        let mockDTO = createMockSearchDTO()
        mockDataTransferService.result = .success(mockDTO)
        
        // When
        let result = try await sut.search(query: "test@#$%^&*()")
        
        // Then
        XCTAssertEqual(mockDataTransferService.requestCallsCount, 1)
        XCTAssertNotNil(result)
    }
    
    func test_search_whenCalledWithUnicodeCharacters_shouldHandleGracefully() async throws {
        // Given
        let mockDTO = createMockSearchDTO()
        mockDataTransferService.result = .success(mockDTO)
        
        // When
        let result = try await sut.search(query: "تجربة")
        
        // Then
        XCTAssertEqual(mockDataTransferService.requestCallsCount, 1)
        XCTAssertNotNil(result)
    }
    
    func test_search_whenCalledWithVeryLongQuery_shouldHandleGracefully() async throws {
        // Given
        let longQuery = String(repeating: "a", count: 1000)
        let mockDTO = createMockSearchDTO()
        mockDataTransferService.result = .success(mockDTO)
        
        // When
        let result = try await sut.search(query: longQuery)
        
        // Then
        XCTAssertEqual(mockDataTransferService.requestCallsCount, 1)
        XCTAssertNotNil(result)
    }
    
    // MARK: - Concurrent Tests
    func test_search_whenCalledConcurrently_shouldHandleMultipleRequests() async throws {
        // Given
        let mockDTO = createMockSearchDTO()
        mockDataTransferService.result = .success(mockDTO)
        
        // When
        async let result1 = sut.search(query: "query1")
        async let result2 = sut.search(query: "query2")
        async let result3 = sut.search(query: "query3")
        
        let results = try await [result1, result2, result3]
        
        // Then
        XCTAssertEqual(results.count, 3)
        XCTAssertEqual(mockDataTransferService.requestCallsCount, 3)
        XCTAssertEqual(mockDataTransferService.requestCalledWithEndpoints.count, 3)
    }
    
    // MARK: - Test Helper Methods
    private func createMockSearchDTO() -> SearchDTO {
        let content = SearchContentDTO(
            podcastID: "podcast1",
            name: "Test Content",
            description: "Test Description",
            avatarURL: "https://example.com/avatar.jpg",
            episodeCount: "10",
            duration: "3600",
            language: "en",
            priority: "1",
            popularityScore: "100",
            score: "4.5"
        )
        
        let section = SearchSectionDTO(
            id: "section1",
            name: "Test Section",
            type: "square",
            contentType: "podcast",
            order: "1",
            content: [content]
        )
        
        return SearchDTO(sections: [section])
    }
    
    private func createMockSearchDTOWithMultipleSections() -> SearchDTO {
        let podcastContent = SearchContentDTO(
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
        
        let bookContent = SearchContentDTO(
            podcastID: "",
            name: "Test Book",
            description: "Test Book Description",
            avatarURL: "https://example.com/book.jpg",
            episodeCount: "0",
            duration: "7200",
            language: "en",
            priority: "2",
            popularityScore: "87",
            score: "4.6"
        )
        
        let podcastSection = SearchSectionDTO(
            id: "section1",
            name: "Podcast Section",
            type: "square",
            contentType: "podcast",
            order: "1",
            content: [podcastContent]
        )
        
        let bookSection = SearchSectionDTO(
            id: "section2",
            name: "Book Section",
            type: "bigSquare",
            contentType: "audioBook",
            order: "2",
            content: [bookContent]
        )
        
        return SearchDTO(sections: [podcastSection, bookSection])
    }
}
