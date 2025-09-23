//
//  HomeView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var todoViewModel = ToDoManager()
    @State private var taskToEdit: Task? = nil
    @State private var showFullLabel: Bool = false
    
    var body: some View {

        NavigationStack {
            VStack{
                List(todoViewModel.tasksBySection){ section in
                    Section {
                        if section.expanded == true {
                            ForEach(section.tasks){task in
                                TaskView(todoViewModel: todoViewModel,
                                         taskToEdit: $taskToEdit,
                                         showFullLabel: $showFullLabel,
                                         task: task,
                                         section: section
                                )
                            }
                            .onMove{ indexSet, destination in
                                todoViewModel.moveTaskInSection(from: indexSet, to: destination, in: section)
                            }
                            .onDelete { indexSet in
                                todoViewModel.delete(at: indexSet, in: section)
                            }
                        }
                        if section.showEditingField == true {
                            CreateInSectionView(toDoManager: todoViewModel, section: section)
                        }
                    } header: {
                        sectionHeader(section)
                    } footer: {
                        createButtonInSection(in: section)
                    }
                }
            }
            .navigationTitle("Tasks")
            .sheet(item: $taskToEdit) { taskToEdit in
                DetailView(toDoManager: todoViewModel, taskToEdit: taskToEdit)
                    .presentationDetents([.medium, .large])
            }
            
        }
    }
    
    
    private func sectionHeader(_ section: TaskSection) -> some View {
        HStack {
            Text(section.id.name)
            Button {
                withAnimation(.spring) {
                    todoViewModel.toggleExpanded(section)
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
                todoViewModel.toggleEditingField(in: section)
            }
        } label: {
            Image(systemName: section.showEditingField ? "minus" : "plus")
                .font(section.expanded ? .body : .footnote)
        }
    }
    
}

#Preview {
    HomeView()
}


