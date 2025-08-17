//
//  SearchContentItemView.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import SwiftUI

// MARK: - Duration Formatting Helper
private func formatDuration(_ duration: String) -> String {
    // First check if it's a numeric duration (like "1702" seconds)
    if let seconds = Int(duration) {
        return formatSecondsToHoursMinutes(seconds)
    }
    
    // Otherwise, handle string format like "1hr 30min"
    let components = duration.components(separatedBy: " ")
    var result: [String] = []
    
    for component in components {
        if component.contains("hr") {
            let hours = component.replacingOccurrences(of: "hr", with: "")
            if let hourValue = Int(hours), hourValue > 0 {
                result.append("\(hourValue)h")
            }
        } else if component.contains("m") {
            let minutes = component.replacingOccurrences(of: "m", with: "")
            if let minuteValue = Int(minutes), minuteValue > 0 {
                result.append("\(minuteValue)m")
            }
        }
    }
    
    return result.isEmpty ? duration : result.joined(separator: " ")
}

private func formatSecondsToHoursMinutes(_ totalSeconds: Int) -> String {
    let hours = totalSeconds / 3600
    let minutes = (totalSeconds % 3600) / 60
    
    var result: [String] = []
    
    if hours > 0 {
        result.append("\(hours)h")
    }
    
    if minutes > 0 {
        result.append("\(minutes)m")
    }
    
    // If both hours and minutes are 0, show seconds
    if result.isEmpty {
        if totalSeconds > 0 {
            result.append("\(totalSeconds)s")
        } else {
            result.append("0m")
        }
    }
    
    return result.joined(separator: " ")
}

// MARK: - Search Square Content View
struct SearchSquareContentView: View {
    let item: SearchContentItemViewModel
    let contentType: SectionContentType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image
            AsyncImage(url: URL(string: item.avatarURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 140, height: 140)
            .cornerRadius(12)
            
            // Title
            Text(item.title)
                .semiBoldFont(size: .headline)
                .fontWeight(.semibold)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Subtitle
            if let subtitle = item.subtitle {
                Text(subtitle)
                    .mediumFont(size: .subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            // Play button and menu actions
            HStack {
                if let duration = item.duration {
                    PlayButtonView(duration: duration) {
                        // Handle play action
                    }
                }
                
                Spacer()
                
                MenuActionsView(onMenuTap: {
                    
                }, onOptionsTap: {
                    
                })
            }
        }
        .frame(width: 140)
    }
}

// MARK: - Search Vertical Content View
struct SearchVerticalContentView: View {
    let item: SearchContentItemViewModel
    let contentType: SectionContentType
    
    var body: some View {
        HStack(spacing: 12) {
            // Image
            AsyncImage(url: URL(string: item.avatarURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 80, height: 80)
            .cornerRadius(8)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                // Title
                Text(item.title)
                    .semiBoldFont(size: .headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Subtitle
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .mediumFont(size: .subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Bottom row with play button and actions
                HStack {
                    if let duration = item.duration {
                        PlayButtonView(duration: duration) {
                            // Handle play action
                        }
                    }
                    
                    Spacer()
                    
                    MenuActionsView(onMenuTap: {
                        
                    }, onOptionsTap: {
                        
                    })
                }
            }
            
            Spacer()
        }
        .frame(height: 80)
    }
}

// MARK: - Search Two Lines Grid Content View
struct SearchTwoLinesGridContentView: View {
    let item: SearchContentItemViewModel
    let contentType: SectionContentType
    
    var body: some View {
        HStack(spacing: 12) {
            // Image
            AsyncImage(url: URL(string: item.avatarURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 60, height: 80)
            .cornerRadius(8)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                // Title
                Text(item.title)
                    .mediumFont(size: .subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Subtitle
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .regularFont(size: .caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Bottom actions
                HStack {
                    if let duration = item.duration {
                        PlayButtonView(duration: duration) {
                            // Handle play action
                        }
                    }
                    
                    Spacer()
                    
                    MenuActionsView(onMenuTap: {
                        
                    }, onOptionsTap: {
                        
                    })
                }
            }
            
            Spacer()
        }
        .frame(width: 200, height: 80)
    }
}

// MARK: - Search Queue Content View
struct SearchQueueContentView: View {
    let item: SearchContentItemViewModel
    let contentType: SectionContentType
    
    var body: some View {
        HStack(spacing: 12) {
            // Image
            AsyncImage(url: URL(string: item.avatarURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 50, height: 70)
            .cornerRadius(8)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                // Title
                Text(item.title)
                    .mediumFont(size: .subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Episode info
                if let episodeCount = item.episodeCount {
                    Text("\(episodeCount) episodes")
                        .regularFont(size: .caption)
                        .foregroundColor(.secondary)
                }
                
                // Duration
                if let duration = item.duration {
                    Text(formatDuration(duration))
                        .regularFont(size: .caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .frame(width: 180, height: 70)
    }
}
