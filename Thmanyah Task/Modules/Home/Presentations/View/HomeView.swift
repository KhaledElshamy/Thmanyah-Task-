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
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.loading != nil {
                    LoadingView()
                } else if !viewModel.error.isEmpty {
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
                        Text("ثمانيه")
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
                ForEach(viewModel.sortedSections) { section in
                    if section.hasContent {
                        SectionView(section: section) { item in
                            viewModel.didSelectItem(item)
                        }
                    }
                }
            }
            .padding(.top, 16)
        }
        .refreshable {
            viewModel.loadHomeSections()
        }
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("جاري التحميل...")
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
            
            Button("إعادة المحاولة") {
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
