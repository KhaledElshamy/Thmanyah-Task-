//
//  HomeRepository.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

final class HomeRepository: HomeRepositoryProtocol {
    private let service: DataTransferService

    init(service: DataTransferService) {
        self.service = service
    }

    func fetchHome(page: Int) async throws -> HomeResponse {
        do {
            let requestDTO = HomeRequestDTO(page: page, limit: nil)
            let endpoint = APIEndPoints.getHomeList(with: requestDTO)
            let homeResponseDTO: HomeResponseDTO = try await service.request(with: endpoint)
            return homeResponseDTO.toDomain()
        } catch let error {
            throw error
        }
    }
}
