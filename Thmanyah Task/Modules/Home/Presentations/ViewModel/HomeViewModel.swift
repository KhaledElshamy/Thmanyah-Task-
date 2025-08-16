//
//  HomeViewModel.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation
import SwiftUI

protocol HomeViewModelInput {
    func loadHomeSections()
    func loadNextPage()
    func refreshData()
    func didSelectItem(_ item: ContentItemViewModel)
    func retry()
}

protocol HomeViewModelOutput {
    var loading: HomeListViewModelLoading? { get }
    var error: String { get }
    var sections: [SectionViewModel] { get }
    var isEmpty: Bool { get }
    var hasMorePages: Bool { get }
    var canLoadMore: Bool { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
}

typealias HomeViewModelProtocol = HomeViewModelInput & HomeViewModelOutput

enum HomeListViewModelLoading {
    case fullScreen
    case nextPage
}

class HomeViewModel: HomeViewModelProtocol, ObservableObject {
    
    // MARK: - Outputs
    @Published var loading: HomeListViewModelLoading? = .none
    @Published var error: String = ""
    @Published var sections: [SectionViewModel] = []
    
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    
    var hasMorePages: Bool { currentPage < totalPageCount }
    var canLoadMore: Bool { hasMorePages && loading != .nextPage }
    
    private var pages: [HomeResponse] = []
    
    var isEmpty: Bool {
        return sections.isEmpty
    }
    
    let emptyDataTitle = NSLocalizedString("No Content Available", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    
    // MARK: - Dependencies
    private let homeUseCase: HomeUseCaseProtocol
    
    // MARK: - Init
    init(homeUseCase: HomeUseCaseProtocol) {
        self.homeUseCase = homeUseCase
    }
    
    private func appendPage(_ homePage: HomeResponse) {
        // Update pagination info using manual page counting
        totalPageCount = homePage.pagination?.totalPages ?? 1
        
        // Increment current page manually since we loaded a new page
        if pages.isEmpty {
            sections = (homePage.sections ?? []).map { SectionViewModel(section: $0) }
        } else {
            let newSectionViewModels = (homePage.sections ?? []).map { SectionViewModel(section: $0) }
            sections.append(contentsOf: newSectionViewModels)
        }
        
        // Simply append the new page (no need for complex duplicate checking)
        pages.append(homePage)
    }
    
    private func resetPages() {
        currentPage = 1
        pages.removeAll()
        sections.removeAll()
    }
}

extension HomeViewModel {
    
    func loadHomeSections() {
        Task {
            await loadFirstPage()
        }
    }
    
    func loadNextPage() {
        guard canLoadMore else { return }
        Task {
            await loadNextPageData()
        }
    }
    
    func refreshData() {
        Task {
            await refreshAllData()
        }
    }
    
    func retry() {
        Task {
            if pages.isEmpty {
                await loadFirstPage()
            } else {
                await loadNextPageData()
            }
        }
    }
    
    func didSelectItem(_ item: ContentItemViewModel) {
        // Handle item selection based on content type
        print("Selected item: \(item.title) of type: \(item.content)")
        // TODO: Navigate to detail screen based on content type
    }
    
    // MARK: - Private Methods
    @MainActor
    private func loadFirstPage() async {
        loading = .fullScreen
        error = ""
        resetPages()
        await fetchPage(pageNumber: currentPage)
    }
    
    @MainActor
    private func loadNextPageData() async {
        guard canLoadMore else { return }
        loading = .nextPage
        error = ""
        currentPage += 1
        await fetchPage(pageNumber: currentPage)
    }
    
    @MainActor
    private func refreshAllData() async {
        loading = .fullScreen
        error = ""
        resetPages()
        await fetchPage(pageNumber: 1)
    }
    
    @MainActor
    private func fetchPage(pageNumber: Int) async {
        do {
            let homeResponse = try await homeUseCase.fetchHome(page: pageNumber)
            appendPage(homeResponse)
            loading = .none
        } catch {
            loading = .none
            self.error = error.localizedDescription
            print("Error loading home sections for page \(pageNumber): \(error)")
        }
    }
}
