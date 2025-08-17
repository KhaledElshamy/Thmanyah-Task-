//
//  TabCoordinator.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 16/08/2025.
//

import Foundation
import SwiftUI

protocol TabCoordinatorProtocol: ObservableObject {
    var activeTab: TabItem { get set }
    
    func selectTab(_ tab: TabItem)
}

final class TabCoordinator: TabCoordinatorProtocol {
    
    // MARK: - Published Properties
    @Published var activeTab: TabItem = .home {
        didSet {
            print("TabCoordinator activeTab changed to: \(activeTab)")
        }
    }
    
    // MARK: - Init
    init() {
        print("TabCoordinator initialized with activeTab: \(activeTab)")
    }
    
    // MARK: - TabCoordinatorProtocol
    func selectTab(_ tab: TabItem) {
        activeTab = tab
    }
}