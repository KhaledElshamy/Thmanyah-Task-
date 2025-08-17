//
//  ContentItemView.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import SwiftUI

struct ContentItemView: View {
    let item: ContentItemViewModel
    let contentType: SectionContentType
    let sectionType: SectionType
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            switch sectionType {
            case .square:
                SquareContentView(item: item, contentType: contentType, sectionType: sectionType)
            case .bigSquare:
                BigSquareContentView(item: item, contentType: contentType, sectionType: sectionType)
            case .twoLinesGrid:
                TwoLinesGridContentView(item: item, contentType: contentType)
            case .queue:
                QueueContentView(item: item, contentType: contentType)
            case .unknown:
                DefaultContentView(item: item, contentType: contentType, sectionType: sectionType)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Square Content View
struct SquareContentView: View {
    let item: ContentItemViewModel
    let contentType: SectionContentType
    let sectionType: SectionType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                            .mediumFont(size: .title2)
                    )
            }
            .frame(width: 120, height: 120)
            .clipped()
            .cornerRadius(8)
            
            Text(item.title)
                .mediumFont(size: .caption)
                .lineLimit(1)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                if let duration = item.duration {
                    PlayButtonView(duration: duration) {
                        // Handle play action
                    }
                }

                Spacer()

                if let releaseDate = item.formattedReleaseDate {
                    Text(releaseDate)
                        .regularFont(size: .caption2)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .foregroundColor(.primary)
                }
            }
        }
        .frame(width: 120, height: 220)
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

// MARK: - Big Square Content View
struct BigSquareContentView: View {
    let item: ContentItemViewModel
    let contentType: SectionContentType
    let sectionType: SectionType
    
    var body: some View {
        // Image with title and episode count overlay
        ZStack(alignment: .bottomLeading) {
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
                            .boldFont(size: .largeTitle)
                    )
            }
            .frame(width: 240, height: 180)
            .clipped()
            .cornerRadius(12)
            
            // Title and episode count overlay at bottom leading
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .mediumFont(size: .subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                if let episodeCount = getEpisodeCount() {
                    Text(episodeCount)
                        .mediumFont(size: .caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
            }
            .padding(.leading, 12)
            .padding(.bottom, 12)
            .padding(.trailing, 12)
        }
        .frame(width: 240, height: 180)
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
    
    private func getEpisodeCount() -> String? {
        // Mock episode/chapter count based on content type
        // In real implementation, this would come from the data model
        switch contentType {
        case .podcast:
            return "10 episodes"
        case .audioBook:
            return "20 episodes"
        case .episode:
            return nil // Individual episodes don't show count
        case .audioArticle:
            return nil // Articles don't show count
        case .unknown:
            return nil
        }
    }
}

// MARK: - Two Lines Grid Content View
struct TwoLinesGridContentView: View {
    let item: ContentItemViewModel
    let contentType: SectionContentType
    
    var body: some View {
        HStack(spacing: 16) {
            // Left: Square thumbnail
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
                            .semiBoldFont(size: .title3)
                    )
            }
            .frame(width: 60, height: 60)
            .clipped()
            .cornerRadius(8)
            
            // Middle: Content details
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .mediumFont(size: .subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 8) {
                    if let authorName = item.authorName {
                        Text(authorName)
                            .mediumFont(size: .caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    if let duration = item.duration {
                        Text("• \(duration)")
                            .mediumFont(size: .caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Second line with additional metadata
                HStack(spacing: 4) {
                    if contentType == .episode {
                        Text("5 hours ago")
                            .regularFont(size: .caption2)
                            .foregroundColor(.secondary)
                    } else {
                        Text(contentTypeDisplayName())
                            .regularFont(size: .caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            // Right: Action buttons
            HStack(spacing: 12) {
                // Options button (three dots)
                Button(action: {
                    // Handle options menu
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                        .semiBoldFont(size: .title3)
                        .frame(width: 24, height: 24)
                }
                
                // Play button
                Button(action: {
                    // Handle play action
                }) {
                    Image(systemName: "play.fill")
                        .foregroundColor(.white)
                        .mediumFont(size: .caption)
                        .frame(width: 32, height: 32)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.clear)
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
    
    private func contentTypeDisplayName() -> String {
        switch contentType {
        case .podcast: return "Podcast"
        case .episode: return "Episode"
        case .audioBook: return "Audiobook"
        case .audioArticle: return "Audio Article"
        case .unknown: return ""
        }
    }
}

// MARK: - Queue Content View
struct QueueContentView: View {
    let item: ContentItemViewModel
    let contentType: SectionContentType
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
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
                            .mediumFont(size: .title2)
                    )
            }
            .frame(width: 60, height: 60)
            .clipped()
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                // Title and author
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .mediumFont(size: .subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    if let authorName = item.authorName {
                        Text(authorName)
                            .mediumFont(size: .subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                // Action buttons row below title
                HStack(spacing: 12) {
                    PlayButtonView(duration: item.duration) {
                        // Handle play action
                    }
                    
                    if let releaseDate = item.formattedReleaseDate {
                        Text(releaseDate)
                            .mediumFont(size: .caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    MenuActionsView(
                        onMenuTap: { /* Handle menu */ },
                        onOptionsTap: { /* Handle options */ }
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(height: 80)
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

// MARK: - Default Content View
struct DefaultContentView: View {
    let item: ContentItemViewModel
    let contentType: SectionContentType
    let sectionType: SectionType
    
    var body: some View {
        SquareContentView(item: item, contentType: contentType, sectionType: sectionType)
    }
}
