//
//  CreateView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import SwiftUI

struct AddTaskField: View {
    @EnvironmentObject var viewModel: ToDoManager
    @State private var draft: Task = Task()
    let section: TaskSection
    
    var body: some View {
        HStack(alignment: .top) {
            TextField("Title", text: $draft.title)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.done)
                .onSubmit {
                    if viewModel.createToDoInSection(draft, in: section){
                        draft = Task() //reset draft
                    }
                }
            Spacer()
            Button {
                if viewModel.createToDoInSection(draft, in: section){
                    draft = Task() //reset draft
                }
            } label: {
                Text("Create")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.vertical,5)
        .alert("", isPresented: $viewModel.showTaskTitleAlert, actions: {
            Button {
                viewModel.showTaskTitleAlert = false
            } label: {
                Text("OK")
            }
        }, message: {
            Text(viewModel.alertMessage)
        })
    }
    

}

#Preview {
    AddTaskField(section: TaskSection(id: .todo))
        .environmentObject(ToDoManager())
}
