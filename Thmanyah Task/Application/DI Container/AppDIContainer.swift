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
            baseURL: URL(string: appConfiguration.homeBaseURL)!
        )
        
        let homeApiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: homeApiDataNetwork)
    }()
    
    lazy var searchDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.searchBaseURL)!
        )
        let searchDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: searchDataNetwork)
    }()
    
    @MainActor
    func makeHomeView() -> HomeView {
        let dependencies = HomeScenesDIContainer.Dependencies(apiDataTransferService: homeApiDataTransferService)
        return HomeScenesDIContainer(dependencies: dependencies).makeHomeView()
    }
}
