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
                List(StatusType.allCases){ status in
                    Section {
                        if toDoManager.expanded[status] == true {
                            ForEach(toDoManager.groupedTask(status)){task in
                                TaskView(toDoManager: toDoManager, task: task)
                            }
                            .onDelete{ indexSet in
                                toDoManager.delete(at: indexSet, by: status)
                            }
                        }
                    } header: {
                        HStack {
                            Text(status.name)
                            Button {
                                withAnimation(.spring) {
                                    toDoManager.toggleExpanded(status)
                                }
                            } label: {
                                Image(systemName:  "chevron.down")
                                    .font(.caption)
                                    .rotationEffect(toDoManager.expanded[status]==true ? .degrees(0) : .degrees(-90))
                            }

                        }
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


