//
//  BoardDetailView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/25/25.
//

import SwiftUI
import SwiftUIReorderableForEach

struct BoardDetailView: View {
    @EnvironmentObject var viewModel: ToDoManager
    
    var body: some View {
        List{
            ForEach(viewModel.currentSections){ section in
                Section {
                    if section.expanded == true {
                        ForEach(section.tasks){task in
                            TaskView(task: task, section: section)
                        }
                        .onMove{ indexSet, destination in
                            viewModel.moveTaskInSection(from: indexSet, to: destination, in: section)
                        }
                        .onDelete { indexSet in
                            viewModel.delete(at: indexSet, in: section)
                        }
                    }
                    if section.showEditingField == true {
                        CreateInSectionView(section: section)
                    }
                } header: {
                    sectionHeader(section)
                } footer: {
                    createButtonInSection(in: section)
                }
            }
        }
        .sheet(item: $viewModel.taskToEdit) { task in
            TaskDetailView(task)
                .environmentObject(viewModel)
        }
        .navigationTitle(viewModel.currentBoardName)
        .navigationBarTitleDisplayMode(.large)
        .environmentObject(viewModel)
    }
    
    private func sectionHeader(_ section: TaskSection) -> some View {
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

    private func createButtonInSection(in section: TaskSection) -> some View{
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
