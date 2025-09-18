//
//  CreateView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import SwiftUI

struct CreateView: View {
    @ObservedObject var toDoManager: ToDoManager
    @State private var draft: Task = Task()
    @Environment(\.dismiss) var dismiss
    var taskToEdit: Task? = nil
    
    init(toDoManager: ToDoManager, taskToEdit: Task? = nil) {
        self.toDoManager = toDoManager
        if let taskToEdit = taskToEdit{
            self.taskToEdit = taskToEdit
            self._draft = State(initialValue: taskToEdit)
        }
       
    }
    
    var body: some View {
        VStack(spacing: 30){
            taskTitle
            priorityView
            createOrUpdateButton
                
            Spacer()

        }
        .padding(.horizontal)
        .alert("", isPresented: $toDoManager.showAlert, actions: {
            Button {
                toDoManager.showAlert = false
            } label: {
                Text("OK")
            }
        }, message: {
            Text(toDoManager.alertMessage)
        })
    }
    
    private var createOrUpdateButton: some View{
        VStack{
            if let taskToEdit = taskToEdit{
                ButtonView(action: {
                    toDoManager.update(old: taskToEdit, new: draft)
                    dismiss()
                }, text: "Update")
            } else {
                ButtonView(action: {
                    toDoManager.createToDo(draft)
                }, text: "Create")
            }
        }
    }
    
    private var taskTitle: some View{
        VStack {
            HStack {
                Text("Task Title")
                    .font(.headline)
                    .padding(.top)
                Spacer()
            }
            TextField("Title", text: $draft.title)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    private var priorityView: some View{
        VStack {
            HStack {
                Text("Priority")
                    .font(.headline)
                    .padding(.top)
                Spacer()
            }
            Picker("Priority", selection: $draft.priority){
                ForEach(Task.PriorityType.allCases){type in
                    Text(type.name)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
}

#Preview {
    CreateView(toDoManager: ToDoManager())
}
