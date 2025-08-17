//
//  HomeUseCaseMock.swift
//  Thmanyah TaskTests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest
@testable import Thmanyah_Task

class HomeUseCaseMock: HomeUseCaseProtocol {
    
    // MARK: - Mock Properties
    var result: Result<HomeResponse, Error>!
    var fetchHomeCallsCount = 0
    var fetchHomeCalledWithPages: [Int] = []
    var shouldThrowError = false
    var mockResponse: HomeResponse?
    var mockError: Error?
    
    // MARK: - Mock Implementation
    func fetchHome(page: Int) async throws -> HomeResponse {
        fetchHomeCallsCount += 1
        fetchHomeCalledWithPages.append(page)
        
        // Use result if configured
        if let result = result {
            switch result {
            case .success(let response):
                return response
            case .failure(let error):
                throw error
            }
        }
        
        // Throw error if configured to do so
        if shouldThrowError {
            if let error = mockError {
                throw error
            } else {
                throw HomeUseCaseMockError.fetchFailed
            }
        }
        
        // Return mock response if available
        if let response = mockResponse {
            return response
        }
        
        // Default response
        throw MockError.fetchFailed
    }
    
    // MARK: - Helper Methods
    func reset() {
        fetchHomeCallsCount = 0
        fetchHomeCalledWithPages.removeAll()
        shouldThrowError = false
        mockResponse = nil
        mockError = nil
        result = nil
    }
    
    func setupSuccessResponse(_ response: HomeResponse) {
        mockResponse = response
        shouldThrowError = false
        result = .success(response)
    }
    
    func setupErrorResponse(_ error: Error) {
        mockError = error
        shouldThrowError = true
        result = .failure(error)
    }
    
    private func createDefaultHomeResponse() -> HomeResponse {
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
}

// MARK: - HomeUseCase Mock Errors
enum HomeUseCaseMockError: Error, Equatable {
    case fetchFailed
    case networkError
    case decodingError
    case invalidResponse
    case timeout
    
    var localizedDescription: String {
        switch self {
        case .fetchFailed:
            return "Mock fetch failed"
        case .networkError:
            return "Mock network error"
        case .decodingError:
            return "Mock decoding error"
        case .invalidResponse:
            return "Mock invalid response"
        case .timeout:
            return "Mock timeout error"
        }
    }
}
