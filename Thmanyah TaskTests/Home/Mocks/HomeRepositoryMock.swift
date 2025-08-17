//
//  HomeRepositoryMock.swift
//  Thmanyah TaskTests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest
@testable import Thmanyah_Task

class HomeRepositoryMock: HomeRepositoryProtocol {
    
    // MARK: - Mock Properties
    var result: Result<HomeResponse, Error>!
    var fetchCompletionCallsCount = 0
    var fetchCalledWithPages: [Int] = []
    
    
    // MARK: - Mock Implementation
    func fetchHome(page: Int) async throws -> HomeResponse {
        
        // Use result if configured
        if let result = result {
            switch result {
            case .success(let response):
                fetchCompletionCallsCount += 1
                fetchCalledWithPages.append(page)
                return response
            case .failure(let error):
                throw error
            }
        }
        
        // If no result is configured, throw an error to indicate the test setup is incomplete
        throw MockError.fetchFailed
    }
}

// MARK: - Mock Errors
enum MockError: Error, Equatable {
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
