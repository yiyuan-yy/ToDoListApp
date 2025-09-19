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
                List{
                    ForEach(Task.StatusType.allCases){status in
                        Section(status.name) {
                            ForEach(toDoManager.groupedTask(status)){task in
                                TaskView(toDoManager: toDoManager, task: task)
                            }
                            .onDelete{ indexSet in
                                toDoManager.delete(at: indexSet, by: status)
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


