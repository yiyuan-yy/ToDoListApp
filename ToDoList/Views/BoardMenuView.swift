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
    @State private var showingAddBoardField = false
    @State private var showingAddError = false
    @State private var showingRenameField = false
    @State private var showingRenameError = false
    
    var body: some View {
        Group {
            if UIDevice.isIPhone {
                compactBoardMenu
            } else {
                sidebarBoardList
            }
        }
        .alert("New Board", isPresented: $showingAddBoardField) {
            TextField("Board name", text: $newBoardName)
            Button("Cancel") {
                newBoardName = ""
                showingAddBoardField = false
            }
            Button("Create") {
                if viewModel.addNewBoard(named: newBoardName) {
                    newBoardName = ""
                } else {
                    showingAddError = true
                }
            }
        }
        .alert("Rename", isPresented: $showingRenameField) {
            TextField("Board name", text: $newBoardName)
            Button("Cancel") {
                newBoardName = ""
                showingRenameField = false
            }
            Button("Done") {
                if viewModel.renameBoard(with: newBoardName) {
                    newBoardName = ""
                } else {
                    showingRenameError = true
                }
            }
        }
        .boardNameAlert(isPresented: $showingRenameError){
            showingRenameField = true
        }
        .boardNameAlert(isPresented: $showingAddError) {
            showingAddBoardField = true
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
//            Button("Rename Board") {
//                showingRenameField = true
//            }
//            Button("Delete Board") {
//                
//            }
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
            showingAddBoardField = true
        } label: {
            Label {
                Text("New Board")
            } icon: {
                Image(systemName: "plus")
            }

        }
    }
}

#Preview {
    BoardMenuView()
        .environmentObject(ToDoManager())
}
