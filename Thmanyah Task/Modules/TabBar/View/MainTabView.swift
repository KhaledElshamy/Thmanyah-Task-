//
//  MainTabView.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import SwiftUI
import Combine

struct MainTabView: View {
    
    // MARK: - Environment Objects
    @EnvironmentObject var tabCoordinator: TabCoordinator
    @EnvironmentObject var diContainer: TabBarDIContainer
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content - Direct view switching instead of TabView
            contentView(for: tabCoordinator.activeTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all, edges: .bottom)
                .onAppear {
                    print("MainTabView appeared with active tab: \(tabCoordinator.activeTab)")
                }
            
            // Custom Tab Bar
            CustomTabBar(activeTab: $tabCoordinator.activeTab)
                .background(.clear)
        }
        .onChange(of: tabCoordinator.activeTab) { newTab in
            tabCoordinator.selectTab(newTab)
        }
    }
    
    // MARK: - Content Views
    @ViewBuilder
    private func contentView(for tab: TabItem) -> some View {
        switch tab {
        case .home:
            diContainer.makeHomeView()
                .onAppear {
                    print("Home view appeared for tab: \(tab)")
                }
        case .search:
            diContainer.makeSearchView()
                .onAppear {
                    print("Search view appeared for tab: \(tab)")
                }
        case .library:
            diContainer.makeLibraryView()
                .onAppear {
                    print("Library view appeared for tab: \(tab)")
                }
        case .explore:
            diContainer.makeExploreView()
                .onAppear {
                    print("Explore view appeared for tab: \(tab)")
                }
        case .profile:
            diContainer.makeProfileView()
                .onAppear {
                    print("Profile view appeared for tab: \(tab)")
                }
        }
    }
}
