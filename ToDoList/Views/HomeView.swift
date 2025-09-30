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
        if UIDevice.isIPhone{
            iphoneHomeView
        } else {
            ipadHomeView
        }
    }
    
    private var iphoneHomeView: some View{
        NavigationStack {
            BoardDetailView()
                .toolbar {
                    ToolbarItem{
                        BoardListView()
                    }
                }
                .environmentObject(viewModel)
        }
        
    }
    
    private var ipadHomeView: some View{
        NavigationSplitView {
            BoardListView()
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


