//
//  TaskView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//
import SwiftUI

struct TaskView: View {
    @StateObject var toDoManager: ToDoManager
    var task: Task
    
    var body: some View {
        HStack {
            Button {
                toDoManager.switchStatus(task)
            } label: {
                Image(systemName: task.status.imgName)
                    .font(.system(size: 20))
            }
            .buttonStyle(.borderless)
            .animation(.spring, value: task.status)
            
            
            NavigationLink (destination: {
                CreateView(toDoManager: toDoManager, taskToEdit: task)
            }, label: {
                HStack {
                    Text(task.title.capitalized)
                    Spacer()
                    
                    Text(task.priority.name)
                        .foregroundStyle(task.priority.textColor)
                        .frame(width: 100, height: 30, alignment: .center)
                        .background(task.priority.backgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            })
            
        }
    }
    
}

#Preview {
    TaskView(toDoManager: ToDoManager(), task: Task())
}
