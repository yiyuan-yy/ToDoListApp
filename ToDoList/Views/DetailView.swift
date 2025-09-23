//
//  DetailView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var toDoManager: ToDoManager
    @State private var draft: Task = Task()
    @Environment(\.dismiss) var dismiss
    var taskToEdit: Task
    
    @State private var showPriorityPicker = false
    @State private var temporyPriority: PriorityType = .normal
    
    
    @State private var showDatePicker = false
    @State private var temporyDDL: Date = Date()
    
    init(toDoManager: ToDoManager, taskToEdit: Task) {
        self.toDoManager = toDoManager
        self.taskToEdit = taskToEdit
        self._draft = State(initialValue: taskToEdit)
        
        self._showDatePicker = State(initialValue: (taskToEdit.ddl != nil) ? true : false)
        self._temporyDDL = State(initialValue: taskToEdit.ddl ?? Date())
        
        self._showPriorityPicker = State(initialValue: (taskToEdit.priority != nil) ? true : false)
        self._temporyPriority = State(initialValue: taskToEdit.priority ?? .normal)
        
    }
    
    var body: some View {
        Form{
            // Title
            TextField("Title", text: $draft.title)
                .textFieldStyle(.plain)
                .font(.title)
                .padding(.top)
            
            HStack {
                LabelButton(controller: $showPriorityPicker, title: "Priority") {
                    draft.priority = nil
                }
                LabelButton(controller: $showDatePicker, title: "Due Date") {
                    draft.ddl = nil
                }
            }
            
            if showPriorityPicker{
                priorityPicker
            }
            
            if showDatePicker{
                DatePicker("Due Date", selection: $temporyDDL, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }
            

            submitButton
        }
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
    
    private var priorityPicker: some View{
        Picker("Priority", selection: $temporyPriority){
            ForEach(PriorityType.allCases){type in
                Text(type.name)
                    .tag(type)
            }
        }
        
    }
    
    private func setDraft(){
        if showDatePicker {
            draft.ddl = temporyDDL
        } else {
            draft.ddl = nil
        }
        
        if showPriorityPicker {
            draft.priority = temporyPriority
        } else {
            draft.priority = nil
        }
        
    }
    
    private var submitButton: some View{
        VStack{
            ButtonView(action: {
                setDraft()
                if (toDoManager.update(old: taskToEdit, new: draft)){
                    dismiss()
                }
            }, text: "Update")
            
        }
    }
    
}

#Preview {
    DetailView(toDoManager: ToDoManager(), taskToEdit: Task())
}
