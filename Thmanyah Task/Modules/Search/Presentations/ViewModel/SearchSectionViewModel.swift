//
//  SearchSectionViewModel.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation

struct SearchSectionViewModel: Identifiable {
    let id = UUID()
    let section: SearchSection
    
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
    
    var content: [SearchContentItemViewModel] {
        return section.content?.map { SearchContentItemViewModel(content: $0) } ?? []
    }
    
    var hasContent: Bool {
        return !content.isEmpty
    }
}
