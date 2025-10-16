//
//  BoardList.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/24/25.
//

import SwiftUI

struct BoardListView: View {
    @EnvironmentObject var viewModel: ToDoManager
    @State private var newBoardName: String = ""
    @State private var showingAddBoardAlert = false
    @State private var showingAddError = false
    
    var body: some View {
        Group {
            if UIDevice.isIPhone {
                compactBoardMenu
            } else {
                sidebarBoardList
            }
        }
        .alert("New Board", isPresented: $showingAddBoardAlert) {
            TextField("Board name", text: $newBoardName)
            Button("Cancel") {
                newBoardName = ""
                showingAddBoardAlert = false
            }
            Button("Create") {
                if viewModel.addNewBoard(named: newBoardName) {
                    newBoardName = ""
                } else {
                    showingAddError = true
                }
            }
        }
        .alert(isPresented: $showingAddError, error: viewModel.addBoardError) { _ in
            Button ("OK") {
                showingAddBoardAlert = true
            }
        } message: { error in
            Text("Please set another name.")
        }
    }

}


// MARK: - Compact Menu (iPhone)
private extension BoardListView {
    var compactBoardMenu: some View{
        Menu {
            boardsList
            Divider()
            createBoardButton
        } label: {
            Label("Boards", systemImage: "rectangle.grid.2x2")
                .font(.title3)
        }
    }
}

// MARK: - Sidebar List (iPad & Mac)
private extension BoardListView {
    var sidebarBoardList: some View{
        List {
           boardsList
       }
       .listStyle(.sidebar)
       .navigationTitle("Boards")
       .toolbar {
           ToolbarItem{
               createBoardButton
           }
       }
    }
}

// MARK: - Components
private extension BoardListView {
    var boardsList: some View{
        ForEach(viewModel.boards){ board in
            Button {
                withAnimation(.spring) {
                    viewModel.switchToBoard(to: board)
                }
            } label: {
                HStack {
//                   Image(systemName: "square.grid.2x2")
                   Text(board.name)
               }
            }
        }
    }
    
    var createBoardButton: some View{
        // Add new board button
        Button {
            showingAddBoardAlert = true
        } label: {
            Label("New Board", systemImage: "plus.circle")
        }
    }
}

#Preview {
    BoardListView()
        .environmentObject(ToDoManager())
}
