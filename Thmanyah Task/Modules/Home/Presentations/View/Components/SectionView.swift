//
//  SectionView.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import SwiftUI

struct SectionView: View {
    let section: SectionViewModel
    let onItemTap: (ContentItemViewModel) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            SectionHeaderView(title: section.title, sectionType: section.sectionType)
            
            // Section Content
            switch section.sectionType {
            case .square, .bigSquare:
                HorizontalScrollSection(section: section, onItemTap: onItemTap)
            case .twoLinesGrid:
                GridSection(section: section, onItemTap: onItemTap)
            case .queue:
                VerticalListSection(section: section, onItemTap: onItemTap)
            case .unknown:
                HorizontalScrollSection(section: section, onItemTap: onItemTap)
            }
        }
        .padding(.bottom, 24)
    }
}

// MARK: - Section Header
struct SectionHeaderView: View {
    let title: String
    let sectionType: SectionType
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button("see more") {
                // Handle "See All" action
            }
            .font(.subheadline)
            .foregroundColor(.accentColor)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Horizontal Scroll Section
struct HorizontalScrollSection: View {
    let section: SectionViewModel
    let onItemTap: (ContentItemViewModel) -> Void
    
    var body: some View {
        if section.sectionType == .unknown {
            // Equal spacing layout for unknown sections
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(section.content.enumerated()), id: \.offset) { index, item in
                        ContentItemView(
                            item: item,
                            contentType: section.contentType,
                            sectionType: section.sectionType
                        ) {
                            onItemTap(item)
                        }
                        .frame(width: 120)
                        
                        if index < section.content.count - 1 {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        } else {
            // Normal spacing for other sections
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(section.content) { item in
                        ContentItemView(
                            item: item,
                            contentType: section.contentType,
                            sectionType: section.sectionType
                        ) {
                            onItemTap(item)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Grid Section (2 Lines Grid)
struct GridSection: View {
    let section: SectionViewModel
    let onItemTap: (ContentItemViewModel) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8)
            ], spacing: 16) {
                ForEach(section.content) { item in
                    TwoLinesGridItemView(
                        item: item,
                        contentType: section.contentType
                    ) {
                        onItemTap(item)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Two Lines Grid Item View
struct TwoLinesGridItemView: View {
    let item: ContentItemViewModel
    let contentType: SectionContentType
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                // Left: Full height thumbnail
                AsyncImage(url: URL(string: item.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: iconForContentType())
                                .foregroundColor(.gray)
                                .font(.title3)
                        )
                }
                .frame(width: 80)
                .clipped()
                .cornerRadius(8)
                
                // Right: Content details
                VStack(alignment: .leading, spacing: 6) {
                    // Title - multiline
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .frame(maxWidth: 200, alignment: .leading)
                    
                    Spacer(minLength: 0)
                    
                    // Play button and actions at bottom
                    HStack {
                        PlayButtonView(duration: item.duration) {
                            // Handle play action
                        }
                        
                        Spacer()
                        
                        MenuActionsView(
                            onMenuTap: { /* Handle menu */ },
                            onOptionsTap: { /* Handle options */ }
                        )
                    }
                }
            }
            .frame(height: 80)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func iconForContentType() -> String {
        switch contentType {
        case .podcast: return "mic.fill"
        case .episode: return "waveform"
        case .audioBook: return "book.fill"
        case .audioArticle: return "doc.text.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }
}

// MARK: - Vertical List Section (Queue) - Carousel Slider
struct VerticalListSection: View {
    let section: SectionViewModel
    let onItemTap: (ContentItemViewModel) -> Void
    
    var body: some View {
        CarouselSliderView(
            items: section.content,
            contentType: section.contentType,
            onItemTap: onItemTap
        )
    }
}

// MARK: - Carousel Slider View with Gesture-Based Navigation
struct CarouselSliderView: View {
    let items: [ContentItemViewModel]
    let contentType: SectionContentType
    let onItemTap: (ContentItemViewModel) -> Void
    
    @State private var currentIndex: Int = 0
    @State private var dragOffsets: [CGFloat] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Fixed container with image carousel and fixed text content
            ZStack {
                HStack(spacing: 16) {
                    // Leading: Image carousel (original stacking behavior with corrected swipe directions)
                    ZStack {
                        ForEach(Array(items.enumerated().reversed()), id: \.offset) { index, item in
                            HStack {
                                ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
                                    AsyncImage(url: URL(string: item.imageURL ?? "")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .overlay(
                                                Image(systemName: iconForContentType())
                                                    .foregroundColor(.gray)
                                                    .font(.title2)
                                            )
                                    }
                                    .frame(width: calculateWidth(), height: calculateHeight(for: index))
                                    .clipped()
                                    .cornerRadius(15)
                                }
                                .offset(x: index - currentIndex <= 3 ? CGFloat(index - currentIndex) * -12 : -36)
                                
                                Spacer(minLength: 0)
                            }
                            .contentShape(Rectangle())
                            .offset(x: index < dragOffsets.count ? dragOffsets[index] : 0)
                        }
                    }
                    .frame(width: 150, height: calculateCarouselHeight()) // Fixed frame for images
                    
                    // Trailing: Fixed text content (changes based on currentIndex)
                    VStack(alignment: .leading, spacing: 8) {
                        // Title
                        Text(currentItem.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        // Duration and play button only
                        HStack(spacing: 8) {
                            if let duration = currentItem.duration {
                                Text(duration)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Play button
                            Button(action: { onItemTap(currentItem) }) {
                                Image(systemName: "play.fill")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Full-width invisible gesture overlay for easy swiping
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation {
                                    // Same gesture logic but accessible from entire view area
                                    if value.translation.width > 0 && currentIndex < items.count - 1 {
                                        // Swiping right (show next)
                                        updateOffset(for: currentIndex, offset: value.translation.width)
                                    } else if value.translation.width < 0 && currentIndex > 0 {
                                        // Swiping left (show previous)
                                        let prevIndex = currentIndex - 1
                                        let newOffset = 350 + value.translation.width
                                        updateOffset(for: prevIndex, offset: newOffset)
                                    }
                                }
                            }
                            .onEnded { value in
                                withAnimation {
                                    if value.translation.width > 0 {
                                        // Right swipe (show next)
                                        if value.translation.width > 80 && currentIndex < items.count - 1 {
                                            updateOffset(for: currentIndex, offset: 350)
                                            currentIndex += 1
                                        } else {
                                            updateOffset(for: currentIndex, offset: 0)
                                        }
                                    } else {
                                        // Left swipe (show previous)
                                        if currentIndex > 0 {
                                            let prevIndex = currentIndex - 1
                                            if -value.translation.width > 80 {
                                                updateOffset(for: prevIndex, offset: 0)
                                                currentIndex -= 1
                                            } else {
                                                updateOffset(for: prevIndex, offset: 350)
                                            }
                                        }
                                    }
                                }
                            }
                    )
            }
            .padding(16)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 12)
        }
        .onAppear {
            dragOffsets = Array(repeating: 0, count: items.count)
        }
    }
    
    private var currentItem: ContentItemViewModel {
        guard currentIndex >= 0 && currentIndex < items.count else {
            return items.first ?? ContentItemViewModel(content: SectionContent(podcastID: nil, episodeID: nil, audiobookID: nil, articleID: nil, name: "", description: nil, avatarURL: nil, duration: nil, authorName: nil, score: nil, releaseDate: nil, audioURL: nil))
        }
        return items[currentIndex]
    }
    
    private func calculateWidth() -> CGFloat {
        return 120 // Fixed small width to leave space for title
    }
    
    private func calculateHeight(for index: Int) -> CGFloat {
        let baseHeight: CGFloat = 100 // Fixed smaller height
        let offset = CGFloat(index - currentIndex) * 6 // Even smaller offset to show 3 books
        return max(baseHeight - offset, 70) // Minimum height of 70
    }
    
    private func calculateCarouselHeight() -> CGFloat {
        return 120 // Fixed compact height
    }
    
    private func updateOffset(for index: Int, offset: CGFloat) {
        if index >= 0 && index < dragOffsets.count {
            dragOffsets[index] = offset
        }
    }
    
    private func iconForContentType() -> String {
        switch contentType {
        case .podcast: return "mic.fill"
        case .episode: return "waveform"
        case .audioBook: return "book.fill"
        case .audioArticle: return "doc.text.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }
    
    private func getEpisodeInfo(for item: ContentItemViewModel) -> String? {
        switch contentType {
        case .podcast:
            return "23 episodes"
        case .episode:
            return "Episode 5"
        case .audioBook:
            return "5 hours"
        case .audioArticle:
            return nil
        case .unknown:
            return nil
        }
    }
}
