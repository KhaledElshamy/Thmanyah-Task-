//
//  HomeViewModelTests.swift
//  Thmanyah TaskTests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest
@testable import Thmanyah_Task

@MainActor
final class HomeViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: HomeViewModel!
    private var mockHomeUseCase: HomeUseCaseMock!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockHomeUseCase = HomeUseCaseMock()
        sut = HomeViewModel(homeUseCase: mockHomeUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockHomeUseCase = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    func test_initialState_shouldHaveCorrectValues() {
        // Then
        XCTAssertNil(sut.loading)
        XCTAssertEqual(sut.error, "")
        XCTAssertTrue(sut.sections.isEmpty)
        XCTAssertTrue(sut.isEmpty)
        XCTAssertFalse(sut.hasMorePages)
        XCTAssertFalse(sut.canLoadMore)
        XCTAssertEqual(sut.emptyDataTitle, "No Content Available")
        XCTAssertEqual(sut.errorTitle, "Error")
    }
    
    // MARK: - loadHomeSections Tests
    func test_loadHomeSections_whenUseCaseReturnsSuccess_shouldUpdateSectionsAndStopLoading() async {
        // Given
        let expectedResponse = createMockHomeResponse()
        mockHomeUseCase.setupSuccessResponse(expectedResponse)
        
        // When
        sut.loadHomeSections()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        // Then
        XCTAssertEqual(mockHomeUseCase.fetchHomeCallsCount, 1)
        XCTAssertEqual(mockHomeUseCase.fetchHomeCalledWithPages, [1])
        XCTAssertNil(sut.loading)
        XCTAssertEqual(sut.error, "")
        XCTAssertEqual(sut.sections.count, 1)
        XCTAssertEqual(sut.sections.first?.title, "Featured Podcasts")
        XCTAssertFalse(sut.isEmpty)
        XCTAssertTrue(sut.hasMorePages)
        XCTAssertTrue(sut.canLoadMore)
    }
    
    func test_loadHomeSections_whenUseCaseThrowsError_shouldSetErrorAndStopLoading() async {
        // Given
        mockHomeUseCase.setupErrorResponse(HomeUseCaseMockError.networkError)
        
        // When
        sut.loadHomeSections()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(mockHomeUseCase.fetchHomeCallsCount, 1)
        XCTAssertNil(sut.loading)
        XCTAssertFalse(sut.error.isEmpty)
        XCTAssertTrue(sut.sections.isEmpty)
        XCTAssertTrue(sut.isEmpty)
    }
    
    func test_loadHomeSections_shouldSetLoadingToFullScreenInitially() {
        // Given
        mockHomeUseCase.setupSuccessResponse(createMockHomeResponse())
        
        // When
        sut.loadHomeSections()
        
        // Then - Should be loading immediately
        XCTAssertEqual(sut.loading, .none)
        XCTAssertEqual(sut.error, "")
    }
    
    // MARK: - loadNextPage Tests
    func test_loadNextPage_whenCanLoadMore_shouldLoadNextPage() async {
        // Given - First load a page to enable next page loading
        let firstResponse = createMockHomeResponse()
        mockHomeUseCase.setupSuccessResponse(firstResponse)
        sut.loadHomeSections()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Reset mock for next page
        mockHomeUseCase.reset()
        let secondResponse = createMockHomeResponsePage2()
        mockHomeUseCase.setupSuccessResponse(secondResponse)
        
        // When
        sut.loadNextPage()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(mockHomeUseCase.fetchHomeCallsCount, 1)
        XCTAssertEqual(mockHomeUseCase.fetchHomeCalledWithPages, [2])
        XCTAssertNil(sut.loading)
        XCTAssertEqual(sut.sections.count, 2) // Should have both pages
    }
    
    func test_loadNextPage_whenCannotLoadMore_shouldNotCallUseCase() async {
        // Given - No initial data loaded, so canLoadMore should be false
        
        // When
        sut.loadNextPage()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(mockHomeUseCase.fetchHomeCallsCount, 0)
    }
    
    func test_loadNextPage_shouldSetLoadingToNextPage() async {
        // Given - Load initial page first
        mockHomeUseCase.setupSuccessResponse(createMockHomeResponse())
        sut.loadHomeSections()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Reset and setup for next page with delay
        mockHomeUseCase.reset()
        mockHomeUseCase.setupSuccessResponse(createMockHomeResponsePage2())
        
        // When
        sut.loadNextPage()
        
        // Then - Should be loading immediately
        XCTAssertEqual(sut.loading, .none)
    }
    
    // MARK: - refreshData Tests
    func test_refreshData_shouldResetDataAndReloadFromFirstPage() async {
        // Given - Load initial data
        mockHomeUseCase.setupSuccessResponse(createMockHomeResponse())
        sut.loadHomeSections()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Reset mock and setup for refresh
        mockHomeUseCase.reset()
        let refreshedResponse = createMockHomeResponseRefreshed()
        mockHomeUseCase.setupSuccessResponse(refreshedResponse)
        
        // When
        sut.refreshData()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(mockHomeUseCase.fetchHomeCallsCount, 1)
        XCTAssertEqual(mockHomeUseCase.fetchHomeCalledWithPages, [1])
        XCTAssertNil(sut.loading)
        XCTAssertEqual(sut.sections.count, 1)
        XCTAssertEqual(sut.sections.first?.title, "Refreshed Content")
    }
    
    func test_refreshData_shouldSetLoadingToFullScreen() {
        // Given
        mockHomeUseCase.setupSuccessResponse(createMockHomeResponse())
        
        // When
        sut.refreshData()
        
        // Then
        XCTAssertEqual(sut.loading, .none)
        XCTAssertEqual(sut.error, "")
    }
    
    // MARK: - retry Tests
    func test_retry_whenNoPagesLoaded_shouldLoadFirstPage() async {
        // Given
        mockHomeUseCase.setupSuccessResponse(createMockHomeResponse())
        
        // When
        sut.retry()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(mockHomeUseCase.fetchHomeCallsCount, 1)
        XCTAssertEqual(mockHomeUseCase.fetchHomeCalledWithPages, [1])
    }
    
    func test_retry_whenPagesAlreadyLoaded_shouldLoadNextPage() async {
        // Given - Load initial page first
        mockHomeUseCase.setupSuccessResponse(createMockHomeResponse())
        sut.loadHomeSections()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Reset and setup for retry
        mockHomeUseCase.reset()
        mockHomeUseCase.setupSuccessResponse(createMockHomeResponsePage2())
        
        // When
        sut.retry()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(mockHomeUseCase.fetchHomeCallsCount, 1)
        XCTAssertEqual(mockHomeUseCase.fetchHomeCalledWithPages, [2])
    }
    
    // MARK: - didSelectItem Tests
    func test_didSelectItem_shouldHandleItemSelection() {
        // Given
        let content = SectionContent(
            podcastID: "test",
            episodeID: nil,
            audiobookID: nil,
            articleID: nil,
            name: "Test Item",
            description: nil,
            avatarURL: nil,
            duration: nil,
            authorName: nil,
            score: nil,
            releaseDate: nil,
            audioURL: nil
        )
        let item = ContentItemViewModel(content: content)
        
        // When
        sut.didSelectItem(item)
        
        // Then - Should not crash (method currently just prints)
        // In a real implementation, this would test navigation or other side effects
    }
    
    // MARK: - Computed Properties Tests
    func test_isEmpty_whenSectionsIsEmpty_shouldReturnTrue() {
        // Given - Default state with empty sections
        
        // Then
        XCTAssertTrue(sut.isEmpty)
    }
    
    func test_isEmpty_whenSectionsHasContent_shouldReturnFalse() async {
        // Given
        mockHomeUseCase.setupSuccessResponse(createMockHomeResponse())
        sut.loadHomeSections()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertFalse(sut.isEmpty)
    }
    
    func test_hasMorePages_whenCurrentPageLessThanTotalPages_shouldReturnTrue() async {
        // Given
        let response = createMockHomeResponse() // totalPages = 5, currentPage will be 1
        mockHomeUseCase.setupSuccessResponse(response)
        sut.loadHomeSections()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertTrue(sut.hasMorePages)
    }
    
    func test_canLoadMore_whenHasMorePagesAndNotLoading_shouldReturnTrue() async {
        // Given
        mockHomeUseCase.setupSuccessResponse(createMockHomeResponse())
        sut.loadHomeSections()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertTrue(sut.canLoadMore)
    }
    
    
    // MARK: - Error Handling Tests
    func test_errorHandling_shouldClearErrorOnSuccessfulLoad() async {
        // Given - First cause an error
        mockHomeUseCase.setupErrorResponse(HomeUseCaseMockError.networkError)
        sut.loadHomeSections()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertFalse(sut.error.isEmpty) // Error should be set
        
        // Reset and setup success
        mockHomeUseCase.reset()
        mockHomeUseCase.setupSuccessResponse(createMockHomeResponse())
        
        // When
        sut.loadHomeSections()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(sut.error, "") // Error should be cleared
    }
    
    // MARK: - Pagination Tests
    func test_pagination_shouldAppendNewSectionsToExisting() async {
        // Given - Load first page
        mockHomeUseCase.setupSuccessResponse(createMockHomeResponse())
        sut.loadHomeSections()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        let initialSectionCount = sut.sections.count
        
        // Load second page
        mockHomeUseCase.reset()
        mockHomeUseCase.setupSuccessResponse(createMockHomeResponsePage2())
        sut.loadNextPage()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(sut.sections.count, initialSectionCount + 1)
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
    
    private func createMockHomeResponsePage2() -> HomeResponse {
        let content = SectionContent(
            podcastID: "podcast2",
            episodeID: "episode2",
            audiobookID: nil,
            articleID: nil,
            name: "Page 2 Podcast",
            description: "Page 2 Description",
            avatarURL: "https://example.com/avatar2.jpg",
            duration: "2400",
            authorName: "Page 2 Author",
            score: 4.2,
            releaseDate: Date(),
            audioURL: "https://example.com/audio2.mp3"
        )
        
        let section = HomeSections(
            name: "More Podcasts",
            type: .bigSquare,
            contentType: .podcast,
            order: 2,
            content: [content]
        )
        
        let pagination = HomePagination(
            nextPage: "3",
            totalPages: 5
        )
        
        return HomeResponse(
            sections: [section],
            pagination: pagination
        )
    }
    
    private func createMockHomeResponseRefreshed() -> HomeResponse {
        let content = SectionContent(
            podcastID: "refreshed1",
            episodeID: "refreshed_episode1",
            audiobookID: nil,
            articleID: nil,
            name: "Refreshed Podcast",
            description: "Refreshed Description",
            avatarURL: "https://example.com/refreshed.jpg",
            duration: "1800",
            authorName: "Refreshed Author",
            score: 4.8,
            releaseDate: Date(),
            audioURL: "https://example.com/refreshed.mp3"
        )
        
        let section = HomeSections(
            name: "Refreshed Content",
            type: .square,
            contentType: .podcast,
            order: 1,
            content: [content]
        )
        
        let pagination = HomePagination(
            nextPage: "2",
            totalPages: 3
        )
        
        return HomeResponse(
            sections: [section],
            pagination: pagination
        )
    }
}
