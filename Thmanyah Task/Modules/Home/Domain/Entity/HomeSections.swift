//
//  HomeSections.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

struct HomeSections {
    let id = UUID()
    var name: String?
    var type: SectionType?
    var contentType: SectionContentType?
    var order: Int?
    var content: [SectionContent]?
}
