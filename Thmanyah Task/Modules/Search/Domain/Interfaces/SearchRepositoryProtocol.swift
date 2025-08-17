//
//  SearchRepositoryProtocol.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation

protocol SearchRepositoryProtocol {
    func search(query: String, page: Int) async throws -> SearchResponse
}