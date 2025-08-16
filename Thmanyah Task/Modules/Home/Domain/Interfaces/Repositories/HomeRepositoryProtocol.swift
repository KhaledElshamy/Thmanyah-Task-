//
//  HomeRepository.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

protocol HomeRepositoryProtocol {
    @discardableResult
    func fetchHome(page: Int) async throws -> HomeResponse
}
