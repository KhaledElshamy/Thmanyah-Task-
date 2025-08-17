//
//  SearchSceneDIContainer.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation

@MainActor
final class SearchScenesDIContainer {

    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Lazy Instances
    private lazy var searchViewModel: SearchViewModel = {
        return SearchViewModel(searchUseCase: makeSearchUseCase())
    }()
    
    init(dependencies: Dependencies){
        self.dependencies = dependencies
    }
    
    func makeSearchView() -> SearchView {
        return SearchView(viewModel: self.makeSearchViewModel())
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        return searchViewModel
    }
    
    // MARK: - Use Cases
    func makeSearchUseCase() -> SearchUseCaseProtocol {
        return SearchUseCase(searchRepository: makeSearchRepository())
    }
    
    // MARK: - Repository
    private func makeSearchRepository() -> SearchRepositoryProtocol {
        return SearchRepository(dataTransferService: dependencies.apiDataTransferService)
    }
}
