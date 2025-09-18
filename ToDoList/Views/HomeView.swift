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
                    ForEach(toDoManager.tasks){task in
                        TaskView(toDoManager: toDoManager, task: task)
                    }
                    .onDelete(perform: toDoManager.delete)
                }
                
            }
            .navigationTitle("Tasks")
            .toolbar{
                Button {
                    toDoManager.showCreateSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $toDoManager.showCreateSheet) {
                CreateView(toDoManager: toDoManager)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    HomeView()
}


