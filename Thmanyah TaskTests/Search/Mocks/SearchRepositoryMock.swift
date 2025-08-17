//
//  SearchRepositoryMock.swift
//  Thmanyah TaskTests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest
@testable import Thmanyah_Task

@MainActor
class SearchRepositoryMock: SearchRepositoryProtocol {
    
    // MARK: - Mock Properties
    var result: Result<SearchResponse, Error>!
    var searchCompletionCallsCount = 0
    var searchCalledWithQueries: [String] = []
    
    // MARK: - Mock Implementation
    func search(query: String) async throws -> SearchResponse {
        
        // Use result if configured
        if let result = result {
            switch result {
            case .success(let response):
                searchCompletionCallsCount += 1
                searchCalledWithQueries.append(query)
                return response
            case .failure(let error):
                throw error
            }
        }
        
        // If no result is configured, throw an error to indicate the test setup is incomplete
        throw SearchMockError.searchFailed
    }
}

// MARK: - Search Mock Errors
enum SearchMockError: Error, Equatable {
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
