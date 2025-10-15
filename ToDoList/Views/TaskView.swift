//
//  TaskView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//
import SwiftUI

struct TaskView: View {
    @EnvironmentObject var viewModel: ToDoManager
    let task: Task
    let section: TaskSection
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.spring) {
                    viewModel.switchTaskStatus(task, in: section)
                }
            } label: {
                Image(systemName: task.status.imgName)
                    .symbolRenderingMode(.palette)
                    .font(.system(size: 18))
                    .foregroundStyle(task.status != .todo ? .white : .blue, task.status == .done ? .darkGreenC : .blue)
            }
            .buttonStyle(.borderless)
        
            
            Button {
                viewModel.taskToEdit = task
            } label: {
                HStack {
                    Text(task.title.capitalized)
                    Spacer()
                }
            }

            // show due date
            dueDateLabel
            
            priorityLabel
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
           
        }

    }
    
    private var dueDateLabel: some View{
        Button{
            withAnimation(.spring) {
                viewModel.showFullDate.toggle()
            }
        } label: {
            if let ddlString = task.formattedDDL {
                Label {
                    Text(viewModel.showFullDate ? ddlString : "")
                        .font(.caption)
                } icon: {
                    Image(systemName: task.ddlImg)
                        .font(.caption)
                }
                .labelStyle(.titleAndIcon)
                .foregroundStyle(task.ddlColor)
            }
        }
        .buttonStyle(.borderless)
    }
    
    private var priorityLabel: some View{
        Button {
            withAnimation(.spring) {
                viewModel.showFullLabel.toggle()
            }
        } label: {
            if let priority = task.priority {
                Text( viewModel.showFullLabel ? priority.name : "")
                    .font(.caption)
                    .foregroundStyle(priority.textColor)
                    .frame(width:  viewModel.showFullLabel ? 60 : 30, height:  viewModel.showFullLabel ? 25 : 10, alignment: .center)
                    .background(priority.backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .buttonStyle(.borderless)

    }
    
    
}

#Preview {
    TaskView(task: Task(title: "Preview Example"), section: TaskSection(id: .doing))
        .environmentObject(ToDoManager())
}

