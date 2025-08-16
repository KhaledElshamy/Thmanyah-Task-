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
    func didSelectItem(_ item: ContentItemViewModel)
    func retry()
}

protocol HomeViewModelOutput {
    var loading: HomeListViewModelLoading? { get }
    var error: String { get }
    var sections: [SectionViewModel] { get }
    var sortedSections: [SectionViewModel] { get }
    var isEmpty: Bool { get }
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
    
    var isEmpty: Bool {
        return sections.isEmpty
    }
    
    var sortedSections: [SectionViewModel] {
        return sections.sorted { lhs, rhs in
            // Handle cases where order might be missing - put them at the end
            let leftOrder = lhs.order
            let rightOrder = rhs.order
            
            if leftOrder == rightOrder {
                // If orders are equal, sort by title for consistency
                return lhs.title < rhs.title
            }
            return leftOrder < rightOrder
        }
    }
    
    let emptyDataTitle = NSLocalizedString("No Content Available", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    
    // MARK: - Dependencies
    private let homeUseCase: HomeUseCaseProtocol
    
    // MARK: - Init
    init(homeUseCase: HomeUseCaseProtocol) {
        self.homeUseCase = homeUseCase
    }
}

extension HomeViewModel {
    
    func loadHomeSections() {
        Task {
            await loadData()
        }
    }
    
    func retry() {
        Task {
            await loadData()
        }
    }
    
    func didSelectItem(_ item: ContentItemViewModel) {
        // Handle item selection based on content type
        print("Selected item: \(item.title) of type: \(item.content)")
        // TODO: Navigate to detail screen based on content type
    }
    
    // MARK: - Private Methods
    @MainActor
    private func loadData() async {
        loading = .fullScreen
        error = ""
        
        do {
            let homeResponse = try await homeUseCase.fetchHome(page: 1)
            let sectionViewModels = homeResponse.sections?
                .map { SectionViewModel(section: $0) } ?? []
            
            sections = sectionViewModels
            loading = .none
        } catch {
            loading = .none
            self.error = error.localizedDescription
            print("Error loading home sections: \(error)")
        }
    }
}
