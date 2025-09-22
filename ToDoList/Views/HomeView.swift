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
    
    var body: some View {

        NavigationStack {
            VStack{
                List(todoViewModel.tasksBySection){ section in
                    Section {
                        if section.expanded == true {
                            ForEach(section.tasks){task in
                                TaskView(todoViewModel: todoViewModel, taskToEdit: $taskToEdit, task: task, section: section)
                            }
                            .onMove{ indexSet, destination in
                                todoViewModel.moveTaskInSection(from: indexSet, to: destination, in: section)
                            }
                            .onDelete { indexSet in
                                todoViewModel.delete(at: indexSet, in: section)
                            }
                            
                        }
                    } header: {
                        sectionHeader(section)
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar{
                createButton
            }
            .sheet(isPresented: $todoViewModel.showCreateSheet) {
                CreateView(toDoManager: todoViewModel)
                    .presentationDetents([.medium, .large])
            }
            .navigationDestination(item: $taskToEdit) { taskToEdit in
                CreateView(toDoManager: todoViewModel, taskToEdit: taskToEdit)
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
    
    private var createButton: some View{
        Button {
            todoViewModel.showCreateSheet = true
        } label: {
            Image(systemName: "plus")
        }
    }
    
    
    
}

#Preview {
    HomeView()
}


