//
//  HomeSceneDIContainer.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation

final class HomeScenesDIContainer {

    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies){
        self.dependencies = dependencies
    }
    
    @MainActor
    func makeHomeView() -> HomeView {
        return HomeView(viewModel: self.makeHomeViewModel())
    }
    
    @MainActor
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(homeUseCase: makeHomeUseCase())
    }
    
    // MARK: - Use Cases
    @MainActor
    private func makeHomeUseCase() -> HomeUseCaseProtocol {
        return HomeUseCase(repository: makeHomeRepository())
    }
    
    // MARK: - Repository
    @MainActor
    private func makeHomeRepository() -> HomeRepositoryProtocol {
        return HomeRepository(service: dependencies.apiDataTransferService)
    }
}
