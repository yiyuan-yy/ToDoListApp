//
//  BoardList.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/24/25.
//

import SwiftUI

struct BoardListView: View {
    @EnvironmentObject var viewModel: ToDoManager
    @State private var draft: String = ""
    @State private var showInputField = false
    
    var body: some View {
        if UIDevice.isIPhone {
            Menu {
                boardsList
                createBoardButton
            } label: {
                Image(systemName: "book")
            }
        } else {
            List {
                boardsList
                createBoardButton
            }
        }

    }
    
    private var boardsList: some View{
        ForEach(viewModel.boards){ board in
            Button(board.name) {
                withAnimation(.spring) {
                    viewModel.switchToBoard(to: board)
                }
            }
        }
    }
    
    private var createBoardButton: some View{
        // Add new board button
        Button {
           
        } label: {
            Image(systemName: "plus")
        }
    }
    
}

#Preview {
    BoardListView()
        .environmentObject(ToDoManager())
}
