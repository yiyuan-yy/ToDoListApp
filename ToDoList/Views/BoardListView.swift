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
        Menu {
            ForEach(viewModel.boards){ board in
                Button(board.name) {
                    withAnimation(.spring) {
                        viewModel.switchToBoard(to: board)
                    }
                }
            }
            
           
            // Add new board button
            Button {
               
            } label: {
                Image(systemName: "plus")
            }

        } label: {
            Image(systemName: "book")
        }
    }
}

#Preview {
    BoardListView()
        .environmentObject(ToDoManager())
}
