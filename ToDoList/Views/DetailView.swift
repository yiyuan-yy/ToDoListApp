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
            // Status Cover
            Section {
                EmptyView() // no content, only header
            } header: {
                Button {
                    withAnimation(.spring){
                        draft.status = draft.status.nextStatus
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text(draft.status.name)
                            .bold()
                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .padding(.vertical, 2)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(draft.status.backColor)
                    )
                    .padding(.horizontal)
                }
            }

            
            // Title
            Section {
                TextField("Enter Title", text: $draft.title)
                    .font(.title2.weight(.semibold))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            
            // Priority & Date
            Section(header: Label("Details", systemImage: "slider.horizontal.3")) {
                HStack {
                    LabelButton(controller: $showPriorityPicker, title: "Priority") {
                        draft.priority = nil
                    }
                    LabelButton(controller: $showDatePicker, title: "Due Date") {
                        draft.ddl = nil
                    }
                    Spacer()
                }
                
                if showPriorityPicker {
                    Picker("Priority", selection: $temporyPriority) {
                        ForEach(PriorityType.allCases) { type in
                            Text(type.name).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                if showDatePicker{
                    DatePicker("Due Date", selection: $temporyDDL, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
            }
            
            // Description
            Section(header: Label("Description", systemImage: "text.justify.left")) {
                ZStack(alignment: .topLeading) {
                    if draft.description.isEmpty {
                        Text("Add notes...")
                            .foregroundColor(.gray.opacity(0.6))
                            .padding(.vertical, 8)
                    }
                    TextEditor(text: $draft.description)
                        .frame(minHeight: 120)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
            }
            
            // Submit
            Section {
                EmptyView()
            } header: {
                Button{
                    setDraft()
                    if (toDoManager.update(old: taskToEdit, new: draft)){
                        dismiss()
                    }
                } label: {
                    Text("Save Task")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            
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
    
}

#Preview {
    DetailView(toDoManager: ToDoManager(), taskToEdit: Task())
}
