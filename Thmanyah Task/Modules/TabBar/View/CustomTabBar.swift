//
//  CustomTabBar.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import SwiftUI

/// Tab Item
enum TabItem: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case library = "Library"
    case explore = "Explore"
    case profile = "Profile"
    
    var symbol: String {
        switch self {
        case .home:
            return "house.fill"
        case .search:
            return "magnifyingglass"
        case .library:
            return "books.vertical.fill"
        case .explore:
            return "safari.fill"
        case .profile:
            return "person.fill"
        }
    }
    
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

struct CustomTabBar: View {
    @Binding var activeTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabItemView(tab: tab, isActive: activeTab == tab)
                    .onTapGesture {
                        activeTab = tab
                    }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
    }
}

struct TabItemView: View {
    let tab: TabItem
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: tab.symbol)
                .mediumFont(size: .title3)
                .foregroundColor(isActive ? .blue : .gray)
            
            Text(tab.rawValue)
                .mediumFont(size: .caption2)
                .foregroundColor(isActive ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isActive ? Color.blue.opacity(0.1) : Color.clear)
        )
    }
}

#Preview {
    CustomTabBar(activeTab: .constant(.home))
}