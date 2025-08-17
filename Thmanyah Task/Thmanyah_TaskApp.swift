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
    @StateObject private var appDIContainer = AppDIContainer()
    
    var body: some Scene {
        WindowGroup {
            MainAppView()
                .environmentObject(appDIContainer)
                .preferredColorScheme(.dark)
        }
    }
}

struct MainAppView: View {
    @EnvironmentObject var appDIContainer: AppDIContainer
    
    var body: some View {
        TabBarDIContainer(appDIContainer: appDIContainer)
            .makeMainTabView()
    }
}
