//
//  SearchViewModel.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation
import SwiftUI
import Combine

protocol SearchViewModelInput {
    func search(query: String)
    func debouncedSearch(query: String)
    func loadInitialData()
    func clearSearch()
    func didSelectItem(_ item: SearchContentItemViewModel)
    func retry()
}

protocol SearchViewModelOutput {
    var loading: SearchListViewModelLoading? { get }
    var error: String { get }
    var sections: [SearchSectionViewModel] { get }
    var isEmpty: Bool { get }
    var isSearching: Bool { get }
    var searchQuery: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
}

typealias SearchViewModelProtocol = SearchViewModelInput & SearchViewModelOutput

enum SearchListViewModelLoading {
    case fullScreen
}

class SearchViewModel: SearchViewModelProtocol, ObservableObject {
    
    // MARK: - Outputs
    @Published var loading: SearchListViewModelLoading? = .none
    @Published var error: String = ""
    @Published var sections: [SearchSectionViewModel] = []
    @Published var isSearching: Bool = false
    @Published var searchQuery: String = ""
    
    private var currentSearchQuery: String = ""
    private var searchTask: Task<Void, Never>?
    
    var isEmpty: Bool {
        return sections.isEmpty && !searchQuery.isEmpty
    }
    
    let emptyDataTitle = NSLocalizedString("No Search Results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    
    // MARK: - Dependencies
    private let searchUseCase: SearchUseCaseProtocol
    
    // MARK: - Init
    init(searchUseCase: SearchUseCaseProtocol) {
        self.searchUseCase = searchUseCase
    }
    
    deinit {
        // Cancel any pending search task when ViewModel is deallocated
        searchTask?.cancel()
    }
    
    // MARK: - Input Methods
    func search(query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        currentSearchQuery = trimmedQuery
        searchQuery = trimmedQuery
        isSearching = true
        
        Task {
            await performSearch(query: trimmedQuery)
        }
    }
    
    func debouncedSearch(query: String) {
        // Cancel the previous search task if it exists
        searchTask?.cancel()
        
        // Create a new search task with 200ms delay
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 200_000_000) // 200 milliseconds
            
            // Check if the task was cancelled
            guard !Task.isCancelled else { return }
            
            // Perform the search on the main actor
            await MainActor.run {
                search(query: query)
            }
        }
    }
    
    func loadInitialData() {
        Task {
            await performSearch(query: "")
        }
    }
    
    func clearSearch() {
        searchQuery = ""
        currentSearchQuery = ""
        isSearching = false
        sections = []
        error = ""
        loading = .none
    }
    
    func didSelectItem(_ item: SearchContentItemViewModel) {
        // Handle item selection based on content type
        print("Selected search item: \(item.title)")
        // TODO: Navigate to detail screen based on content type
    }
    
    func retry() {
        Task {
            await performSearch(query: currentSearchQuery)
        }
    }
    
    // MARK: - Private Methods
    @MainActor
    private func performSearch(query: String) async {
        loading = .fullScreen
        error = ""
        
        do {
            let searchResponse = try await searchUseCase.search(query: query)
            sections = (searchResponse.sections ?? []).map { SearchSectionViewModel(section: $0) }
            loading = .none
            isSearching = false
        } catch {
            loading = .none
            isSearching = false
            self.error = error.localizedDescription
            print("Error searching for '\(query)': \(error)")
        }
    }

}
