//
//  HomeUseCases.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

protocol HomeUseCaseProtocol {
    func fetchHome(page: Int) async throws -> HomeResponse
}

class HomeUseCase: HomeUseCaseProtocol {
    
    private let homeRepository: HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol) {
        self.homeRepository = repository
    }
    
    func fetchHome(page: Int) async throws -> HomeResponse {
        return try await homeRepository.fetchHome(page: page)
    }
}
