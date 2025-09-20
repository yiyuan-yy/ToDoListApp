//
//  HomeView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var toDoManager = ToDoManager()
    
    var body: some View {

        NavigationStack {
            VStack{
                List(toDoManager.tasksBySection){ section in
                    Section {
                        if section.expanded == true {
                            ForEach(section.tasks){task in
                                TaskView(toDoManager: toDoManager, task: task, section: section)
                            }
                            .onDelete { indexSet in
                                toDoManager.delete(at: indexSet, in: section)
                            }
                            .onMove{ indexSet, destination in
                                toDoManager.moveTaskInSection(from: indexSet, to: destination, section: section)
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
            .sheet(isPresented: $toDoManager.showCreateSheet) {
                CreateView(toDoManager: toDoManager)
                    .presentationDetents([.medium, .large])
            }
        }
    }
    
    private func sectionHeader(_ section: TaskSection) -> some View {
        HStack {
            Text(section.id.name)
            Button {
                withAnimation(.spring) {
                    toDoManager.toggleExpanded(section)
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
            toDoManager.showCreateSheet = true
        } label: {
            Image(systemName: "plus")
        }
    }
    
}

#Preview {
    HomeView()
}


