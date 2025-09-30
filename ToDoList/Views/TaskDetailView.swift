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
    
    private var submitButton: some View{
        // Submit
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
    
    private var descriptionField: some View{
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
    }
    
    private var detailsField: some View{
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
    }
    
    private var titleField: some View{
        // Title
        Section {
            TextField("Enter Title", text: $draft.title)
                .font(.title2.weight(.semibold))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
    }
    
    private var statusView: some View{
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
    TaskDetailView(Task())
        .environmentObject(ToDoManager())
}
