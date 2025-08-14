//
//  HomeView.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation
import SwiftUI


struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var diContainer: AppDIContainer
    
    var body: some View {
        Text("Hello, World!")
    }
}
