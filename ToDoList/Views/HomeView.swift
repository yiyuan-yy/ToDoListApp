//
//  HomeView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = ToDoManager()
    
    var body: some View {
        NavigationStack {
            VStack{
                List(viewModel.tasksBySection){ section in
                    Section {
                        if section.expanded == true {
                            ForEach(section.tasks){task in
                                TaskView(task: task,
                                         section: section
                                )
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
            .navigationTitle("Tasks")
            .toolbar{
                ToolbarItem {
                    
                }
            }
            .sheet(item: $viewModel.taskToEdit) { task in
                DetailView(task)
            }
            .environmentObject(viewModel)
        }
       
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
    HomeView()
}


