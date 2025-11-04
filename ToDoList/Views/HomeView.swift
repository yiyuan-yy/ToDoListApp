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
    
    #if os(iOS)
    private var iOSLayout: some View{
        Group{
            if UIDevice.isIPhone { // for iPhone
                NavigationStack {
                    BoardDetailView()
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                BoardMenuView()
                            }
                        }
                        .environmentObject(viewModel)
                }
            } else { // for iPad
                splitHomeView
            }
        }
    }
    #endif
    
    #if os(macOS)
    private var macLayout: some View{
        splitHomeView // for Mac
    }
    #endif
    
    var body: some View {
        #if os(iOS)
        iOSLayout
        #elseif os(macOS)
        macLayout
        #endif
    }
    
    // MARK: - Split Home View (iPad & Mac)
    private var splitHomeView: some View{
        NavigationSplitView {
            BoardMenuView()
                .navigationTitle("Boards")
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


