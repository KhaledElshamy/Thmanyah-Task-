//
//  HomeRequestDTO.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 25/06/2025.
//

import Foundation

struct HomeRequestDTO: Codable {
    let page: Int?
    let limit: Int?
    
    init(page: Int? = nil, limit: Int? = nil) {
        self.page = page
        self.limit = limit
    }
}