//
//  MenuActionsView.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import SwiftUI

struct MenuActionsView: View {
    let onMenuTap: () -> Void
    let onOptionsTap: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: onMenuTap) {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.secondary)
                    .mediumFont(size: .caption)
                    .frame(width: 20, height: 20)
            }
            
            Button(action: onOptionsTap) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.secondary)
                    .mediumFont(size: .title3)
                    .frame(width: 24, height: 24)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    MenuActionsView(
        onMenuTap: { print("Menu tapped") },
        onOptionsTap: { print("Options tapped") }
    )
    .padding()
}
