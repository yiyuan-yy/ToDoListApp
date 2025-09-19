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
    
    @State private var showDatePicker = false
    @State private var dueDate: Date = Date()
    
    init(toDoManager: ToDoManager, taskToEdit: Task? = nil) {
        self.toDoManager = toDoManager
        if let taskToEdit = taskToEdit{
            self.taskToEdit = taskToEdit
            self._draft = State(initialValue: taskToEdit)
            self._showDatePicker = State(initialValue: taskToEdit.ddlExist)
            self._dueDate = State(initialValue: taskToEdit.ddl ?? Date())
        }
    }
    
    var body: some View {
        VStack(spacing: 35){
            taskTitle
                .padding(.top, 30)
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
                    setDDL()
                    if (toDoManager.update(old: taskToEdit, new: draft)){
                        dismiss()
                    }
                }, text: "Update")
            } else {
                ButtonView(action: {
                    setDDL()
                    toDoManager.createToDo(draft)
                }, text: "Create")
            }
        }
    }
    
    private func setDDL(){
        if showDatePicker {
            draft.ddl = dueDate
        } else {
            draft.ddl = nil
        }
    }
    
    private var taskTitle: some View{
        VStack {
            HStack {
                Text("Task Title")
                    .font(.headline)
                    .padding(.top)
                Spacer()
                dueDateField
            }
            TextField("Title", text: $draft.title)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    private var dueDateField: some View{
        HStack {
            Button {
                showDatePicker.toggle()
            } label: {
                if !showDatePicker{
                    Label {
                        Text("Due Date")
                    } icon: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .foregroundStyle(.primary)
                } else {
                    Spacer()
                    Image(systemName: "minus.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .red)
                }
            }
            if showDatePicker{
                DatePicker("", selection: $dueDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }
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
