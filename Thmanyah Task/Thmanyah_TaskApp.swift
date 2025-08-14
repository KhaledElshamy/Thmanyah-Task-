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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
