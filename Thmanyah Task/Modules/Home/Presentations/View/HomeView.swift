//
//  HomeView.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var diContainer: AppDIContainer
    @EnvironmentObject var tabCoordinator: TabCoordinator
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.loading == .fullScreen {
                    LoadingView()
                } else if !viewModel.error.isEmpty && viewModel.sections.isEmpty {
                    ErrorView(
                        title: viewModel.errorTitle,
                        message: viewModel.error,
                        retryAction: {
                            viewModel.retry()
                        }
                    )
                } else if viewModel.sections.isEmpty {
                    EmptyStateView(title: viewModel.emptyDataTitle)
                } else {
                    contentView
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "waveform")
                            .foregroundColor(.accentColor)
                        Text("Thmanyah")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadHomeSections()
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.sections) { section in
                    if section.hasContent {
                        SectionView(section: section) { item in
                            viewModel.didSelectItem(item)
                        }
                    }
                }
                
                // Load More Section
                if viewModel.hasMorePages {
                    loadMoreView
                        .onAppear {
                            viewModel.loadNextPage()
                        }
                } else if !viewModel.sections.isEmpty {
                    endOfListView
                }
                
                // Bottom padding for tab bar
                Color.clear
                    .frame(height: 100)
            }
            .padding(.top, 16)
        }
        .refreshable {
            await performRefresh()
        }
    }
    
    private var loadMoreView: some View {
        VStack(spacing: 12) {
            if viewModel.loading == .nextPage {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading more...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else if !viewModel.error.isEmpty {
                VStack(spacing: 8) {
                    Text("Failed to load more")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    
                    Button("Retry") {
                        viewModel.loadNextPage()
                    }
                    .font(.caption)
                    .foregroundColor(.accentColor)
                }
            }
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
    }
    
    private var endOfListView: some View {
        VStack {
            Divider()
                .padding(.horizontal)
            
            Text("All content loaded")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.vertical, 16)
        }
    }
    
    @MainActor
    private func performRefresh() async {
        viewModel.refreshData()
        // Wait for the refresh to complete
        while viewModel.loading == .fullScreen {
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        }
    }
    

}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Error View
struct ErrorView: View {
    let title: String
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                retryAction()
            }
            .buttonStyle(.borderedProminent)
            .font(.headline)
        }
        .padding()
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "rectangle.stack.badge.minus")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
