//
//  SectionViewModel.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

struct SectionViewModel: Identifiable {
    let id = UUID()
    let section: HomeSections
    
    var title: String {
        return section.name ?? ""
    }
    
    var sectionType: SectionType {
        return section.type ?? .unknown
    }
    
    var contentType: SectionContentType {
        return section.contentType ?? .unknown
    }
    
    var order: Int {
        return section.order ?? 0
    }
    
    var content: [ContentItemViewModel] {
        return section.content?.map { ContentItemViewModel(content: $0) } ?? []
    }
    
    var hasContent: Bool {
        return !content.isEmpty
    }
}
