//
//  CreateView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import SwiftUI

struct CreateInSectionView: View {
    @EnvironmentObject var viewModel: ToDoManager
    @State private var draft: Task = Task()
    let section: TaskSection
    
    var body: some View {
        HStack(alignment: .top) {
            TextField("Title", text: $draft.title)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
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

#Preview {
    CreateInSectionView(section: TaskSection(id: .todo))
        .environmentObject(ToDoManager())
}
