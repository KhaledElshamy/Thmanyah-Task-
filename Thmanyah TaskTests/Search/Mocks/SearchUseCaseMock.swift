//
//  SearchUseCaseMock.swift
//  Thmanyah TaskTests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest
@testable import Thmanyah_Task

class SearchUseCaseMock: SearchUseCaseProtocol {
    
    // MARK: - Mock Properties
    var result: Result<SearchResponse, Error>!
    var searchCallsCount = 0
    var searchCalledWithQueries: [String] = []
    var shouldThrowError = false
    var mockResponse: SearchResponse?
    var mockError: Error?
    var delayInSeconds: TimeInterval = 0
    
    // MARK: - Mock Implementation
    func search(query: String) async throws -> SearchResponse {
        searchCallsCount += 1
        searchCalledWithQueries.append(query)
        
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
                throw SearchUseCaseMockError.searchFailed
            }
        }
        
        // Return mock response if available
        if let response = mockResponse {
            return response
        }
        
        // Default response
        return createDefaultSearchResponse()
    }
    
    // MARK: - Helper Methods
    func reset() {
        searchCallsCount = 0
        searchCalledWithQueries.removeAll()
        shouldThrowError = false
        mockResponse = nil
        mockError = nil
        delayInSeconds = 0
        result = nil
    }
    
    func setupSuccessResponse(_ response: SearchResponse) {
        mockResponse = response
        shouldThrowError = false
        result = .success(response)
    }
    
    func setupErrorResponse(_ error: Error) {
        mockError = error
        shouldThrowError = true
        result = .failure(error)
    }
    
    private func createDefaultSearchResponse() -> SearchResponse {
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
}

// MARK: - SearchUseCase Mock Errors
enum SearchUseCaseMockError: Error, Equatable {
    case searchFailed
    case networkError
    case decodingError
    case invalidQuery
    case timeout
    
    var localizedDescription: String {
        switch self {
        case .searchFailed:
            return "Mock search failed"
        case .networkError:
            return "Mock network error"
        case .decodingError:
            return "Mock decoding error"
        case .invalidQuery:
            return "Mock invalid query"
        case .timeout:
            return "Mock timeout error"
        }
    }
}
