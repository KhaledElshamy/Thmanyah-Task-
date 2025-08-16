//
//  PlayButtonView.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import SwiftUI

struct PlayButtonView: View {
    let duration: String?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 4) {
                Image(systemName: "play.fill")
                    .foregroundColor(.white)
                    .font(.caption2)
                
                if let duration = duration {
                    Text(formatDuration(duration))
                        .font(.caption2)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.8))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Helper Functions
    private func formatDuration(_ duration: String) -> String {
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
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        PlayButtonView(duration: "1hr 30m") {}
        PlayButtonView(duration: "0hr 45m") {}
        PlayButtonView(duration: "2hr 0m") {}
        PlayButtonView(duration: nil) {}
    }
    .padding()
}
