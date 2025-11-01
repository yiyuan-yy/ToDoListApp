//
//  BoardDetailView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/25/25.
//

import SwiftUI

struct BoardDetailView: View {
    @EnvironmentObject var viewModel: ToDoManager
    @State private var isDropTargeted = false
    @State private var newBoardName: String = ""
    @State private var showingRenameField = false
    @State private var showingCloseAlert = false
    @State private var showingRenameError = false
    @State private var showingDeleteError = false
    
    
    var body: some View {
        List{
            sectionView(viewModel.currentSections[0])
            sectionView(viewModel.currentSections[1])
            sectionView(viewModel.currentSections[2])
        }
        .listStyle(.insetGrouped)
        .sheet(item: $viewModel.taskToEdit) { task in
            TaskDetailView(task)
                .environmentObject(viewModel)
        }
        .navigationTitle(viewModel.currentBoardName)
        .navigationBarTitleDisplayMode(.large)
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

// MARK: - Components
private extension BoardDetailView {
    func sectionView(_ section: TaskSection) -> some View{
        Section {
            if section.expanded == true {
                ForEach(section.tasks){task in
                    TaskInListView(task: task, section: section)
//                    .draggable(task.id.uuidString)
                }
                .onMove{ indexSet, destination in
                    viewModel.moveTaskInSection(from: indexSet, to: destination, in: section)
                }
                .onDelete { indexSet in
                    viewModel.delete(at: indexSet, in: section)
                }
            }
            if section.showEditingField == true {
                AddTaskField(section: section)
            }
        } header: {
            sectionHeader(section)
        } footer: {
            createButtonInSection(in: section)
        }
//        .dropDestination(for: String.self) { ids, _ in
//            if let taskID = ids.first {
//                viewModel.moveTaskToSection(taskID, to: section)
//            }
//            print("dropped")
//            return true
//        }
    }
    
    func sectionHeader(_ section: TaskSection) -> some View {
        HStack {
            Text(section.id.name)
            Button {
                withAnimation(.spring) {
                    viewModel.toggleExpanded(section)
                }
            } label: {
                Image(systemName:  "chevron.down")
                    .font(.caption)
                    .rotationEffect(section.expanded == true ? .degrees(0) : .degrees(-90))
            }
        }
    }

    func createButtonInSection(in section: TaskSection) -> some View{
        Button {
            withAnimation(.spring) {
                viewModel.toggleEditingField(in: section)
            }
        } label: {
            Image(systemName: section.showEditingField ? "minus" : "plus")
                .font(section.expanded ? .body : .footnote)
        }
    }
}

#Preview {
    BoardDetailView()
        .environmentObject(ToDoManager())
}
