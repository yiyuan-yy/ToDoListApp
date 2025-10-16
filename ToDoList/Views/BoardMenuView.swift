//
//  BoardList.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/24/25.
//

import SwiftUI

struct BoardMenuView: View {
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
private extension BoardMenuView {
    var compactBoardMenu: some View{
        Menu {
            boardsList
            Divider()
            createBoardButton
        } label: {
            Label("Boards", systemImage: "rectangle.grid.2x2")
        }
    }
}

// MARK: - Sidebar List (iPad & Mac)
private extension BoardMenuView {
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
private extension BoardMenuView {
    var boardsList: some View{
        ForEach(viewModel.boards){ board in
            Button {
                withAnimation(.spring) {
                    viewModel.switchToBoard(to: board)
                }
            } label: {
                HStack {
                   Text(board.name)
                    Spacer()
                    if viewModel.isCurrentBoard(board) {
                        Image(systemName: "checkmark")
                    }
               }
                .padding()
                .background(
                    viewModel.isCurrentBoard(board)
                    ? Color.accentColor.opacity(0.2)
                    : Color.clear
                )
                .cornerRadius(8)
            }
        }
    }
    
    
    var createBoardButton: some View{
        // Add new board button
        Button {
            showingAddBoardAlert = true
        } label: {
            Label {
                Text("New Board")
            } icon: {
                Image(systemName: "plus.circle")
            }

        }
    }
}

#Preview {
    BoardMenuView()
        .environmentObject(ToDoManager())
}
