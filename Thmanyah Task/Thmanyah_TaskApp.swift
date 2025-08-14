//
//  Thmanyah_TaskApp.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 14/08/2025.
//

import SwiftUI

@main
struct Thmanyah_TaskApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var diContainer = AppDIContainer()
    
    var body: some Scene {
        WindowGroup {
            diContainer.makeHomeView()
                .environmentObject(diContainer)
                .preferredColorScheme(.dark)
        }
    }
}
