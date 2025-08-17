//
//  SearchRepository.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation

final class SearchRepository: SearchRepositoryProtocol {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func search(query: String, page: Int = 1) async throws -> SearchResponse {
        let word = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let endpoint = SearchAPIEndPoints.search(word: word.isEmpty ? nil : word)
        let searchDTO = try await dataTransferService.request(with: endpoint)
        return searchDTO.toDomain()
    }
}