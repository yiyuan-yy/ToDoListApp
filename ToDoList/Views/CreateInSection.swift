//
//  CreateView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import SwiftUI

struct CreateInSectionView: View {
    @ObservedObject var toDoManager: ToDoManager
    @State private var draft: Task = Task()
    let section: TaskSection
    
    var body: some View {
        HStack(alignment: .top) {
            TextField("Title", text: $draft.title)
                .textFieldStyle(.roundedBorder)
            Spacer()
            Button {
                if toDoManager.createToDoInSection(draft, in: section){
                    draft = Task() //reset draft
                }
            } label: {
                Text("Create")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.vertical,5)
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
}

#Preview {
    CreateInSectionView(toDoManager: ToDoManager(),section: TaskSection(id: .todo))
}
