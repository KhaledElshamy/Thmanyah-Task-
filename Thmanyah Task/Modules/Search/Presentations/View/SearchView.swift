//
//  SearchView.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar - Fixed at top
                SearchBar(text: $searchText, onSearchButtonClicked: {
                    // Perform immediate search when user presses search button
                    viewModel.search(query: searchText)
                })
                .padding(.horizontal)
                .padding(.bottom, 8)
                .background(Color(.systemBackground))
                .zIndex(1) // Ensure search bar stays on top
                .onChange(of: searchText) { _ in
                    viewModel.debouncedSearch(query: searchText)
                }
                
                // Content Area
                GeometryReader { geometry in
                    ZStack {
                        if viewModel.loading == .fullScreen {
                            LoadingView()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        } else if !viewModel.error.isEmpty && viewModel.sections.isEmpty {
                            ErrorView(
                                title: viewModel.errorTitle,
                                message: viewModel.error,
                                retryAction: {
                                    viewModel.retry()
                                }
                            )
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        } else if viewModel.isEmpty {
                            EmptyStateView(title: viewModel.emptyDataTitle)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        } else {
                            contentView
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline) // Use inline to save space
        }
        .onAppear {
            if viewModel.sections.isEmpty && viewModel.loading == nil {
                viewModel.loadInitialData()
            }
        }
        .onDisappear {
            // View cleanup if needed
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.sections) { section in
                    SearchSectionView(section: section) { item in
                        viewModel.didSelectItem(item)
                    }
                }

                // Bottom padding for tab bar
                Color.clear
                    .frame(height: 100)
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var text: String
    let onSearchButtonClicked: () -> Void
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Search Icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(isSearchFocused ? .blue : .gray)
                .font(.system(size: 16, weight: .medium))
                .animation(.easeInOut(duration: 0.2), value: isSearchFocused)
            
            // Text Field
            TextField("Search for podcasts, books, articles...", text: $text)
                .focused($isSearchFocused)
                .font(.system(size: 16))
                .submitLabel(.search)
                .onSubmit {
                    onSearchButtonClicked()
                }
            
            // Clear Button
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    onSearchButtonClicked() // Trigger immediate search with empty text
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSearchFocused ? Color.blue : Color.clear, lineWidth: 2)
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isSearchFocused)
    }
}
