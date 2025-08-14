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
        return HomeViewModel()
    }
}
