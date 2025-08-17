//
//  TabBarDIContainer.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation
import SwiftUI

@MainActor
final class TabBarDIContainer: ObservableObject {
    
    // MARK: - Dependencies
    private let appDIContainer: AppDIContainer
    

    
    private lazy var tabCoordinator: TabCoordinator = {
        return TabCoordinator()
    }()
    
    // MARK: - Init
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
        // MARK: - Tab Coordinator
    func makeTabCoordinator() -> TabCoordinator {
        return tabCoordinator
    }
    

    
    // MARK: - Tab Views
    func makeHomeView() -> some View {
        return appDIContainer.makeHomeView()
    }
    
    func makeSearchView() -> some View {
        return appDIContainer.makeSearchView()
    }
    
    func makeLibraryView() -> some View {
        return PlaceholderTabView(tabName: "Library")
    }
    
    func makeExploreView() -> some View {
        return PlaceholderTabView(tabName: "Explore")
    }
    
    func makeProfileView() -> some View {
        return PlaceholderTabView(tabName: "Profile")
    }
    
    // MARK: - Main Tab View
    func makeMainTabView() -> some View {
        return MainTabView()
            .environmentObject(self)
            .environmentObject(makeTabCoordinator())
    }
    

}

// MARK: - Placeholder Tab View
struct PlaceholderTabView: View {
    let tabName: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "hammer.fill")
                .regularFont(size: .huge, scale: false)
                .foregroundColor(.gray)
            
            Text("\(tabName) Tab")
                .boldFont(size: .title)
            
            Text("Coming Soon...")
                .regularFont(size: .subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}
