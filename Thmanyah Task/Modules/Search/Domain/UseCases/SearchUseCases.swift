//
//  SearchUseCases.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation

// MARK: - Search Use Case Protocol
protocol SearchUseCaseProtocol {
    func search(query: String) async throws -> SearchResponse
}

// MARK: - Search Use Case
final class SearchUseCase: SearchUseCaseProtocol {
    
    private let searchRepository: SearchRepositoryProtocol
    
    init(searchRepository: SearchRepositoryProtocol) {
        self.searchRepository = searchRepository
    }
    
    func search(query: String) async throws -> SearchResponse {
        return try await searchRepository.search(query: query)
    }
}

// MARK: - Search Error
enum SearchError: Error {
    case invalidQuery
    case networkError
    case decodingError
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .invalidQuery:
            return "Invalid search query"
        case .networkError:
            return "Network error occurred"
        case .decodingError:
            return "Failed to decode search results"
        case .unknownError:
            return "Unknown error occurred"
        }
    }
}