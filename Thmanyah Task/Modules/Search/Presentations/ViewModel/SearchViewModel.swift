//
//  SearchViewModel.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation
import SwiftUI

protocol SearchViewModelInput {
    func search(query: String)
    func loadInitialData()
    func loadNextPage()
    func refreshData()
    func clearSearch()
    func didSelectItem(_ item: SearchContentItemViewModel)
    func retry()
}

protocol SearchViewModelOutput {
    var loading: SearchListViewModelLoading? { get }
    var error: String { get }
    var sections: [SearchSectionViewModel] { get }
    var isEmpty: Bool { get }
    var hasMorePages: Bool { get }
    var canLoadMore: Bool { get }
    var isSearching: Bool { get }
    var searchQuery: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
}

typealias SearchViewModelProtocol = SearchViewModelInput & SearchViewModelOutput

enum SearchListViewModelLoading {
    case fullScreen
    case nextPage
}

class SearchViewModel: SearchViewModelProtocol, ObservableObject {
    
    // MARK: - Outputs
    @Published var loading: SearchListViewModelLoading? = .none
    @Published var error: String = ""
    @Published var sections: [SearchSectionViewModel] = []
    @Published var isSearching: Bool = false
    @Published var searchQuery: String = ""
    
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var currentSearchQuery: String = ""
    
    var hasMorePages: Bool { currentPage < totalPageCount }
    var canLoadMore: Bool { hasMorePages && loading != .nextPage && !searchQuery.isEmpty }
    
    private var pages: [SearchResponse] = []
    
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
    
    // MARK: - Input Methods
    func search(query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        currentSearchQuery = trimmedQuery
        searchQuery = trimmedQuery
        isSearching = true
        
        Task {
            await performSearch(query: trimmedQuery, page: 1)
        }
    }
    
    func loadInitialData() {
        Task {
            await performSearch(query: "", page: 1)
        }
    }
    
    func loadNextPage() {
        guard canLoadMore else { return }
        
        Task {
            await loadNextPageData()
        }
    }
    
    func refreshData() {
        guard !currentSearchQuery.isEmpty else { return }
        
        Task {
            await refreshAllData()
        }
    }
    
    func clearSearch() {
        searchQuery = ""
        currentSearchQuery = ""
        isSearching = false
        sections = []
        pages = []
        currentPage = 0
        totalPageCount = 1
        error = ""
        loading = .none
    }
    
    func didSelectItem(_ item: SearchContentItemViewModel) {
        // Handle item selection based on content type
        print("Selected search item: \(item.title)")
        // TODO: Navigate to detail screen based on content type
    }
    
    func retry() {
        guard !currentSearchQuery.isEmpty else { return }
        
        Task {
            if sections.isEmpty {
                await performSearch(query: currentSearchQuery, page: 1)
            } else {
                await loadNextPageData()
            }
        }
    }
    
    // MARK: - Private Methods
    @MainActor
    private func performSearch(query: String, page: Int) async {
        if page == 1 {
            loading = .fullScreen
            resetPages()
        } else {
            loading = .nextPage
        }
        
        error = ""
        
        do {
            let searchResponse = try await searchUseCase.search(query: query, page: page)
            appendPage(searchResponse)
            loading = .none
            isSearching = false
        } catch {
            loading = .none
            isSearching = false
            self.error = error.localizedDescription
            print("Error searching for '\(query)' on page \(page): \(error)")
        }
    }
    
    @MainActor
    private func loadNextPageData() async {
        guard canLoadMore else { return }
        loading = .nextPage
        error = ""
        currentPage += 1
        await performSearch(query: currentSearchQuery, page: currentPage)
    }
    
    @MainActor
    private func refreshAllData() async {
        loading = .fullScreen
        error = ""
        resetPages()
        await performSearch(query: currentSearchQuery, page: 1)
    }
    
    private func appendPage(_ searchPage: SearchResponse) {
        // Update pagination info
        totalPageCount = searchPage.pagination?.totalPages ?? 1
        
        // Increment current page manually since we loaded a new page
        if pages.isEmpty {
            currentPage = 1
            sections = (searchPage.sections ?? []).map { SearchSectionViewModel(section: $0) }
        } else {
            let newSectionViewModels = (searchPage.sections ?? []).map { SearchSectionViewModel(section: $0) }
            sections.append(contentsOf: newSectionViewModels)
        }
        
        // Simply append the new page
        pages.append(searchPage)
    }
    
    private func resetPages() {
        currentPage = 0
        pages.removeAll()
        sections.removeAll()
    }
}