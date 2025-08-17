//
//  AppDIContainer.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 14/08/2025.
//

import Foundation

final class AppDIContainer: ObservableObject {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var homeApiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: "https://" + appConfiguration.homeBaseURL)!
        )
        
        let homeApiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: homeApiDataNetwork)
    }()
    
    lazy var searchDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: "https://" + appConfiguration.searchBaseURL)!
        )
        let searchDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: searchDataNetwork)
    }()
    

    
    // MARK: - Home Scene
    @MainActor
    lazy var homeScenesDIContainer: HomeScenesDIContainer = {
        let dependencies = HomeScenesDIContainer.Dependencies(
            apiDataTransferService: homeApiDataTransferService
        )
        return HomeScenesDIContainer(dependencies: dependencies)
    }()
    
    @MainActor
    func makeHomeView() -> HomeView {
        return homeScenesDIContainer.makeHomeView()
    }
    
    @MainActor
    func makeHomeViewModel() -> HomeViewModel {
        return homeScenesDIContainer.makeHomeViewModel()
    }
    
    // MARK: - Search Scene
    @MainActor
    lazy var searchScenesDIContainer: SearchScenesDIContainer = {
        let dependencies = SearchScenesDIContainer.Dependencies(
            apiDataTransferService: searchDataTransferService
        )
        return SearchScenesDIContainer(dependencies: dependencies)
    }()
    
    @MainActor
    func makeSearchView() -> SearchView {
        return searchScenesDIContainer.makeSearchView()
    }
    
    @MainActor
    func makeSearchViewModel() -> SearchViewModel {
        return searchScenesDIContainer.makeSearchViewModel()
    }
}
