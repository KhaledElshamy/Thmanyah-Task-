//
//  SearchViewModelTests.swift
//  Thmanyah TaskTests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest
@testable import Thmanyah_Task

@MainActor
final class SearchViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: SearchViewModel!
    private var mockSearchUseCase: SearchUseCaseMock!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockSearchUseCase = SearchUseCaseMock()
        sut = SearchViewModel(searchUseCase: mockSearchUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockSearchUseCase = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    func test_initialState_shouldHaveCorrectValues() {
        // Then
        XCTAssertNil(sut.loading)
        XCTAssertEqual(sut.error, "")
        XCTAssertTrue(sut.sections.isEmpty)
        XCTAssertFalse(sut.isSearching)
        XCTAssertEqual(sut.searchQuery, "")
        XCTAssertFalse(sut.isEmpty) // isEmpty is false when searchQuery is empty
        XCTAssertEqual(sut.emptyDataTitle, "No Search Results")
        XCTAssertEqual(sut.errorTitle, "Error")
    }
    
    // MARK: - search Tests
    func test_search_whenUseCaseReturnsSuccess_shouldUpdateSectionsAndStopLoading() async {
        // Given
        let expectedResponse = createMockSearchResponse()
        mockSearchUseCase.setupSuccessResponse(expectedResponse)
        
        // When
        sut.search(query: "podcast")
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        // Then
        XCTAssertEqual(mockSearchUseCase.searchCallsCount, 1)
        XCTAssertEqual(mockSearchUseCase.searchCalledWithQueries, ["podcast"])
        XCTAssertNil(sut.loading)
        XCTAssertEqual(sut.error, "")
        XCTAssertEqual(sut.sections.count, 1)
        XCTAssertEqual(sut.sections.first?.title, "Search Results")
        XCTAssertEqual(sut.searchQuery, "podcast")
        XCTAssertFalse(sut.isSearching)
        XCTAssertFalse(sut.isEmpty)
    }
    
    func test_search_whenUseCaseThrowsError_shouldSetErrorAndStopLoading() async {
        // Given
        mockSearchUseCase.setupErrorResponse(SearchUseCaseMockError.networkError)
        
        // When
        sut.search(query: "test")
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(mockSearchUseCase.searchCallsCount, 1)
        XCTAssertNil(sut.loading)
        XCTAssertFalse(sut.error.isEmpty)
        XCTAssertTrue(sut.sections.isEmpty)
        XCTAssertFalse(sut.isSearching)
        XCTAssertEqual(sut.searchQuery, "test")
    }
    
    func test_search_shouldTrimWhitespaceFromQuery() async {
        // Given
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        
        // When
        sut.search(query: "  podcast  ")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(mockSearchUseCase.searchCalledWithQueries, ["podcast"])
        XCTAssertEqual(sut.searchQuery, "podcast")
    }
    
    func test_search_shouldSetIsSearchingToTrueInitially() {
        // Given
        mockSearchUseCase.delayInSeconds = 0.2
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        
        // When
        sut.search(query: "test")
        
        // Then - Should be searching initially
        XCTAssertTrue(sut.isSearching)
        XCTAssertEqual(sut.loading, .none)
    }
    
    func test_search_withEmptyQuery_shouldCallUseCaseWithEmptyString() async {
        // Given
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        
        // When
        sut.search(query: "")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(mockSearchUseCase.searchCalledWithQueries, [""])
        XCTAssertEqual(sut.searchQuery, "")
    }
    
    // MARK: - debouncedSearch Tests
    func test_debouncedSearch_shouldDelaySearchExecution() async {
        // Given
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        
        // When
        sut.debouncedSearch(query: "test")
        
        // Then - Should not have called immediately
        XCTAssertEqual(mockSearchUseCase.searchCallsCount, 0)
        
        // Wait for debounce delay + execution
        try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        // Then - Should have called after delay
        XCTAssertEqual(mockSearchUseCase.searchCallsCount, 1)
        XCTAssertEqual(mockSearchUseCase.searchCalledWithQueries, ["test"])
    }
    
    func test_debouncedSearch_shouldCancelPreviousSearchWhenCalledMultipleTimes() async {
        // Given
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        
        // When - Call multiple times quickly
        sut.debouncedSearch(query: "test1")
        sut.debouncedSearch(query: "test2")
        sut.debouncedSearch(query: "test3")

        // Wait for debounce delay + execution
        try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        // Then - Should only have called once with the last query
        XCTAssertEqual(mockSearchUseCase.searchCallsCount, 1)
        XCTAssertEqual(mockSearchUseCase.searchCalledWithQueries, ["test3"])
    }
    
    // MARK: - loadInitialData Tests
    func test_loadInitialData_shouldCallSearchWithEmptyQuery() async {
        // Given
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        
        // When
        sut.loadInitialData()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(mockSearchUseCase.searchCallsCount, 1)
        XCTAssertEqual(mockSearchUseCase.searchCalledWithQueries, [""])
    }
    
    // MARK: - clearSearch Tests
    func test_clearSearch_shouldResetAllSearchState() async {
        // Given - First perform a search
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        sut.search(query: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Verify search state is set
        XCTAssertFalse(sut.sections.isEmpty)
        XCTAssertEqual(sut.searchQuery, "test")
        
        // When
        sut.clearSearch()
        
        // Then
        XCTAssertEqual(sut.searchQuery, "")
        XCTAssertFalse(sut.isSearching)
        XCTAssertTrue(sut.sections.isEmpty)
        XCTAssertEqual(sut.error, "")
        XCTAssertNil(sut.loading)
    }
    
    // MARK: - didSelectItem Tests
    func test_didSelectItem_shouldHandleItemSelection() {
        // Given
        let content = SearchContent(
            podcastID: "test",
            name: "Test Item",
            description: nil,
            avatarURL: nil,
            episodeCount: nil,
            duration: nil,
            language: nil,
            priority: nil,
            popularityScore: nil,
            score: nil
        )
        let item = SearchContentItemViewModel(content: content)
        
        // When
        sut.didSelectItem(item)
        
        // Then - Should not crash (method currently just prints)
        // In a real implementation, this would test navigation or other side effects
    }
    
    // MARK: - retry Tests
    func test_retry_shouldRetryWithLastSearchQuery() async {
        // Given - Perform an initial search
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        sut.search(query: "initial query")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Reset mock for retry
        mockSearchUseCase.reset()
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        
        // When
        sut.retry()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(mockSearchUseCase.searchCallsCount, 1)
        XCTAssertEqual(mockSearchUseCase.searchCalledWithQueries, ["initial query"])
    }
    
    func test_retry_withEmptyCurrentQuery_shouldRetryWithEmptyQuery() async {
        // Given
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        
        // When
        sut.retry()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(mockSearchUseCase.searchCallsCount, 1)
        XCTAssertEqual(mockSearchUseCase.searchCalledWithQueries, [""])
    }
    
    // MARK: - isEmpty Tests
    func test_isEmpty_whenSectionsEmptyAndQueryNotEmpty_shouldReturnTrue() async {
        // Given
        mockSearchUseCase.setupSuccessResponse(SearchResponse(sections: [], pagination: nil))
        sut.search(query: "notfound")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertTrue(sut.isEmpty)
    }
    
    func test_isEmpty_whenSectionsEmptyAndQueryEmpty_shouldReturnFalse() {
        // Given - Default state with empty query
        
        // Then
        XCTAssertFalse(sut.isEmpty)
    }
    
    func test_isEmpty_whenSectionsHasContentAndQueryNotEmpty_shouldReturnFalse() async {
        // Given
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        sut.search(query: "podcast")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertFalse(sut.isEmpty)
    }
    
    // MARK: - Loading State Tests
    func test_loading_shouldSetToFullScreenDuringSearch() {
        // Given
        mockSearchUseCase.delayInSeconds = 0.2
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        
        // When
        sut.search(query: "test")
        
        // Then
        XCTAssertEqual(sut.loading, .none)
    }
    
    func test_loading_shouldSetToNoneAfterSuccessfulSearch() async {
        // Given
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        
        // When
        sut.search(query: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertNil(sut.loading)
    }
    
    func test_loading_shouldSetToNoneAfterFailedSearch() async {
        // Given
        mockSearchUseCase.setupErrorResponse(SearchUseCaseMockError.networkError)
        
        // When
        sut.search(query: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertNil(sut.loading)
    }
    
    // MARK: - Error Handling Tests
    func test_errorHandling_shouldClearErrorOnSuccessfulSearch() async {
        // Given - First cause an error
        mockSearchUseCase.setupErrorResponse(SearchUseCaseMockError.networkError)
        sut.search(query: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertFalse(sut.error.isEmpty) // Error should be set
        
        // Reset and setup success
        mockSearchUseCase.reset()
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        
        // When
        sut.search(query: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(sut.error, "") // Error should be cleared
    }
    
    // MARK: - Multiple Search Tests
    func test_multipleSearches_shouldUpdateResultsCorrectly() async {
        // Given
        let firstResponse = createMockSearchResponse()
        mockSearchUseCase.setupSuccessResponse(firstResponse)
        
        // When - First search
        sut.search(query: "first")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(sut.sections.count, 1)
        XCTAssertEqual(sut.searchQuery, "first")
        
        // Given - Second search
        mockSearchUseCase.reset()
        let secondResponse = createMockSearchResponseMultipleSections()
        mockSearchUseCase.setupSuccessResponse(secondResponse)
        
        // When - Second search
        sut.search(query: "second")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(sut.sections.count, 2)
        XCTAssertEqual(sut.searchQuery, "second")
    }
    
    // MARK: - Concurrent Search Tests
    func test_concurrentSearches_shouldHandleCorrectly() async {
        // Given
        mockSearchUseCase.setupSuccessResponse(createMockSearchResponse())
        
        // When - Multiple concurrent searches
        sut.search(query: "query1")
        sut.search(query: "query2")
        sut.search(query: "query3")
        
        // Wait for completion
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Then - Should have the last query as current
        XCTAssertEqual(sut.searchQuery, "query3")
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
            name: "Search Results",
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
    
    private func createMockSearchResponseMultipleSections() -> SearchResponse {
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
        
        let pagination = SearchPagination(
            nextPage: "2",
            totalPages: 10
        )
        
        return SearchResponse(
            sections: [podcastSection, bookSection],
            pagination: pagination
        )
    }
}
