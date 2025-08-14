//
//  HomeViewModel.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation


protocol HomeViewModelInput {
    func didLoadNextPage()
    func didSelectItem(at index: Int)
}

protocol HomeViewModelOutput {
    var loading: Observable<HomeListViewModelLoading?> { get }
    var error: Observable<String> { get }
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
    
    var loading: Observable<HomeListViewModelLoading?> = Observable(.none)
    var error: Observable<String> = Observable("")
    var isEmpty: Bool { return true }
    let emptyDataTitle = NSLocalizedString("No Movies", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    
    
}

extension HomeViewModel {
    func didLoadNextPage() {
        
    }
    
    func didSelectItem(at index: Int) {
        
    }
}
