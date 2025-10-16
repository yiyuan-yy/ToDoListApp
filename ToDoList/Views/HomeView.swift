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
        Group{
            if UIDevice.isIPhone{
                compactView
            } else {
                splitHomeView
            }
        }
        
    }
    
    // MARK: - Compact Home View (iPhone)
    private var compactView: some View{
        NavigationStack {
            BoardDetailView()
                .toolbar {
                    ToolbarItem{
                        BoardMenuView()
                    }
                }
                .environmentObject(viewModel)
        }
        
    }
    
    // MARK: - Split Home View (iPad & Mac)
    private var splitHomeView: some View{
        NavigationSplitView {
            BoardMenuView()
                .navigationTitle("Boards")
                .navigationSplitViewColumnWidth(
                            min: 150, ideal: 250, max: 400)
                .environmentObject(viewModel)
        } detail: {
            BoardDetailView()
                .environmentObject(viewModel)
        }
        .navigationSplitViewStyle(.balanced)
    }
    
}

#Preview {
    HomeView()
}


