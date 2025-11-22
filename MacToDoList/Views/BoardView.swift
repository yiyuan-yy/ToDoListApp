//
//  BoardDetailView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/25/25.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var viewModel: ToDoManager
    @State private var isDropTargeted = false
    @State private var newBoardName: String = ""
    @State private var showingRenameField = false
    @State private var showingCloseAlert = false
    @State private var showingRenameError = false
    @State private var showingDeleteError = false
    
    
    var body: some View {
        ScrollView{
            HStack(alignment: .top, spacing: 20){
                SectionView(section: viewModel.currentSections[0])
                SectionView(section: viewModel.currentSections[1])
                SectionView(section: viewModel.currentSections[2])
            }
            .padding()
        }
            .sheet(item: $viewModel.taskToEdit) { task in
                TaskDetailView(task)
                    .environmentObject(viewModel)
            }
            .navigationTitle(viewModel.currentBoardName)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        // Rename board
                        Button {
                            showingRenameField = true
                        } label: {
                            Label {
                                Text("Rename Board")
                            } icon: {
                                Image(systemName: "pencil")
                            }
                        }
                        
                        // Colse Board
                        Button {
                            // if the board is the only board, show alert
                            if viewModel.boards.count == 1{
                                showingDeleteError = true
                            } else {
                                showingCloseAlert = true
                            }
                            
                        } label: {
                            Label {
                                Text("Close Board")
                            } icon: {
                                Image(systemName: "minus.circle")
                            }
                        }
                    }
                    label: {
                        Label("Edit",  systemImage: "ellipsis.circle")
                            .labelStyle(.iconOnly)
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
            .alert("Delete This Board?",
                   isPresented: $showingCloseAlert)
            {
                Button("Cancel", role: .cancel) { }
                
                Button("Delete Forever", role: .destructive) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        viewModel.deleteCurrentBoard()
                    }
                }
            } message: {
                Text("""
            This action is permanent and cannot be undone.
            
            All tasks and data associated with this board will be deleted forever.
            """)
            }
            .alert("At Least One Board Required",
                   isPresented: $showingDeleteError)
            {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Create another board before deleting this one.")
            }
            .boardNameAlert(isPresented: $showingRenameError){
                showingRenameField = true
            }
            .environmentObject(viewModel)
        }
    
}


#Preview {
    BoardView()
        .environmentObject(ToDoManager())
}
