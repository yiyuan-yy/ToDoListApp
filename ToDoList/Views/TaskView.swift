//
//  TaskView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//
import SwiftUI

struct TaskView: View {
    @StateObject var todoViewModel: ToDoManager
    @Binding var taskToEdit: Task?
    @Binding var showFullLabel: Bool
    
    let task: Task
    let section: TaskSection
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.spring) {
                    todoViewModel.switchTaskStatus(task, in: section)
                }
            } label: {
                Image(systemName: task.status.imgName)
                    .symbolRenderingMode(.palette)
                    .font(.system(size: 18))
                    .foregroundStyle(task.status != .todo ? .white : .blue, task.status == .done ? .darkGreenC : .blue)
            }
            .buttonStyle(.borderless)
        
            
            Button {
                taskToEdit = task
            } label: {
                HStack {
                    Text(task.title.capitalized)
                    Spacer()
                }
            }

            VStack (alignment: .leading) {
                priorityLabel
                // show due date
                if let ddlString = task.formattedDDL {
                    Label {
                        if task.status != .done{
                            Text(ddlString)
                                .font(.caption)
                        } else {
                            EmptyView()
                        }
                    } icon: {
                        Image(systemName: task.ddlImg)
                            .font(.caption)
                    }
                    .labelStyle(.titleAndIcon)
                    .foregroundStyle(task.ddlColor)
                    
                    
                }
            }
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
           
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

