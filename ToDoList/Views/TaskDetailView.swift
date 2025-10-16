//
//  TaskDetailView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var viewModel: ToDoManager
    
    @State private var draft: Task = Task()
    
    @State private var showPriorityPicker = false
    @State private var temporyPriority: PriorityType = .normal
    
    @State private var showDatePicker = false
    @State private var temporyDDL: Date = Date()
    
    init(_ task: Task) {
        self._draft = State(initialValue: task)
        self._showDatePicker = State(initialValue: (task.ddl != nil) ? true : false)
        self._temporyDDL = State(initialValue: task.ddl ?? Date())
        
        self._showPriorityPicker = State(initialValue: (task.priority != nil) ? true : false)
        self._temporyPriority = State(initialValue: task.priority ?? .normal)
    }
    
    var body: some View {
        Form{
            statusView
            titleField
            detailsField
            descriptionField
            submitButton
        }
        .alert("", isPresented: $viewModel.showAlert, actions: {
            Button {
                viewModel.showAlert = false
            } label: {
                Text("OK")
            }
        }, message: {
            Text(viewModel.alertMessage)
        })
    }
    
}

// MARK: - Component
private extension TaskDetailView {
    // init the draft in the form
    func setDraft(){
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
    
    // Submit
    var submitButton: some View{
        Section {
            EmptyView()
        } header: {
            Button{
                guard let taskToEdit = viewModel.taskToEdit else {return}
                setDraft()
                if (viewModel.update(old: taskToEdit, new: draft)){
                    viewModel.taskToEdit = nil
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
    
    // Description
   var descriptionField: some View{
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
    }
    
    // Priority & Date
   var detailsField: some View{
        Section(header: Label("Details", systemImage: "slider.horizontal.3")) {
            HStack {
                TaskLabelButton(controller: $showPriorityPicker, title: "Priority") {
                    draft.priority = nil
                }
                TaskLabelButton(controller: $showDatePicker, title: "Due Date") {
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
    }
    
    // Title
    var titleField: some View{
        Section {
            TextField("Enter Title", text: $draft.title)
                .font(.title2.weight(.semibold))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
    }
    
    // Status Cover
   var statusView: some View{
        Section {
            EmptyView() // no content, only header
        } header: {
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
}

#Preview {
    TaskDetailView(Task())
        .environmentObject(ToDoManager())
}
