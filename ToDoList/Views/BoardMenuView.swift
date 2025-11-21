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
    
    var body: some View {
        Group {
            #if os(iOS)
            if UIDevice.isIPhone {
                compactBoardMenu
            } else {
                sidebarBoardList
            }
            #elseif os(macOS)
            sidebarBoardList
            #endif
            
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
        } label: {
            Label("Boards", systemImage: "rectangle.grid.2x2")
                .labelStyle(.iconOnly)
        }
    }
}

// MARK: - Sidebar List (iPad & Mac)
private extension BoardMenuView {
    var sidebarBoardList: some View{
        List {
           boardsList
                .listRowSeparator(.hidden)
       }
        .listStyle(.inset)
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
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
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
            .buttonStyle(.borderless)
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
