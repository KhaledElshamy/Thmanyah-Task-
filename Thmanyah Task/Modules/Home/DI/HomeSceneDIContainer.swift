//
//  HomeSceneDIContainer.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

@MainActor
final class HomeScenesDIContainer {

    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Lazy Instances
    private lazy var homeViewModel: HomeViewModel = {
        return HomeViewModel(homeUseCase: makeHomeUseCase())
    }()
    
    init(dependencies: Dependencies){
        self.dependencies = dependencies
    }
    
    func makeHomeView() -> HomeView {
        return HomeView(viewModel: self.makeHomeViewModel())
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        return homeViewModel
    }
    
    // MARK: - Use Cases
    func makeHomeUseCase() -> HomeUseCaseProtocol {
        return HomeUseCase(repository: makeHomeRepository())
    }
    
    // MARK: - Repository
    private func makeHomeRepository() -> HomeRepositoryProtocol {
        return HomeRepository(service: dependencies.apiDataTransferService)
    }
}
