//
//  APIEndPoints.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

struct APIEndPoints {
    
    static func getHomeList(with homeRequestDTO: HomeRequestDTO = HomeRequestDTO()) -> Endpoint<HomeResponseDTO> {

        return Endpoint(
            path: "home_sections",
            method: .get,
            queryParametersEncodable: homeRequestDTO
        )
    }
}
