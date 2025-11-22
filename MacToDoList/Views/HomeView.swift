//
//  HomeView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = ToDoManager()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        NavigationSplitView {
            BoardMenuView()
                .navigationTitle("Boards")
                .environmentObject(viewModel)
        } detail: {
            BoardView()
                .environmentObject(viewModel)
        }
        .navigationSplitViewStyle(.balanced)
    }
    
}

#Preview {
    HomeView()
}


