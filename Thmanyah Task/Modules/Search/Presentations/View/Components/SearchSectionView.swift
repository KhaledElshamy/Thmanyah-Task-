//
//  SearchSectionView.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import SwiftUI

struct SearchSectionView: View {
    let section: SearchSectionViewModel
    let onItemTap: (SearchContentItemViewModel) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !section.title.isEmpty {
                SectionHeaderView(title: section.title, sectionType: section.sectionType)
            }
            
            switch section.sectionType {
            case .square, .bigSquare:
                HorizontalSearchSection(section: section, onItemTap: onItemTap)
            case .twoLinesGrid:
                GridSearchSection(section: section, onItemTap: onItemTap)
            case .queue:
                QueueSearchSection(section: section, onItemTap: onItemTap)
            case .unknown:
                HorizontalSearchSection(section: section, onItemTap: onItemTap)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Horizontal Search Section
struct HorizontalSearchSection: View {
    let section: SearchSectionViewModel
    let onItemTap: (SearchContentItemViewModel) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(section.content) { item in
                    SearchSquareContentView(item: item, contentType: section.contentType)
                        .onTapGesture {
                            onItemTap(item)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Grid Search Section
struct GridSearchSection: View {
    let section: SearchSectionViewModel
    let onItemTap: (SearchContentItemViewModel) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 16) {
                ForEach(section.content) { item in
                    SearchTwoLinesGridContentView(item: item, contentType: section.contentType)
                        .onTapGesture {
                            onItemTap(item)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Queue Search Section (Simplified)
struct QueueSearchSection: View {
    let section: SearchSectionViewModel
    let onItemTap: (SearchContentItemViewModel) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(section.content) { item in
                    SearchQueueContentView(item: item, contentType: section.contentType)
                        .onTapGesture {
                            onItemTap(item)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}
