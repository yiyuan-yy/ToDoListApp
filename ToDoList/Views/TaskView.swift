//
//  TaskView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//
import SwiftUI

struct TaskView: View {
    @StateObject var toDoManager: ToDoManager
    let task: Task
    @State var showFullLabel = false
    @State private var navigateToDetail = false
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.spring) {
                    toDoManager.switchStatus(task)
                }
            } label: {
                Image(systemName: task.status.imgName)
                    .symbolRenderingMode(.palette)
                    .font(.system(size: 18))
                    .foregroundStyle(task.status != .todo ? .white : .blue, task.status == .done ? .darkGreenC : .blue)
            }
            .buttonStyle(.borderless)
        
            
            Button {
                navigateToDetail = true
            } label: {
                HStack {
                    Text(task.title.capitalized)
                    Spacer()
                }
            }

            priorityLabel
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
           
        }
        .navigationDestination(isPresented: $navigateToDetail) {
            CreateView(toDoManager: toDoManager, taskToEdit: task)
        }
    }
    
    private var priorityLabel: some View{
        Button {
            showFullLabel.toggle()
        } label: {
            if let priority = task.priority {
                Text(showFullLabel ? priority.name : "")
                    .font(.caption)
                    .foregroundStyle(priority.textColor)
                    .frame(width: showFullLabel ? 60 : 30, height: showFullLabel ? 25 : 10, alignment: .center)
                    .background(priority.backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .buttonStyle(.borderless)
        .animation(.spring, value: showFullLabel)

    }
    
    
}

