//
//  BoardList.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/24/25.
//

import SwiftUI

struct BoardList: View {
    @EnvironmentObject var viewModel: ToDoManager
    
    var body: some View {
        Menu {
            ForEach(viewModel.boards){ board in
                Button(board.name) {
                    viewModel.switchToBoard(to: board)
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
    BoardList()
        .environmentObject(ToDoManager())
}
