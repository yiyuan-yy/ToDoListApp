//
//  LabelButton.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/23/25.
//

import SwiftUI

struct LabelButton: View {
    @Binding var controller: Bool
    var title: String = ""
    var removeAction: ()->Void
    
    var body: some View {
        Button(controller ? "Remove \(title)" : "Add \(title)") {
            withAnimation(.spring){
                if controller{
                    controller = false
                    removeAction()
                } else {
                    controller = true
                }
            }
        }
        .buttonStyle(.bordered)
        .font(.caption)
        .tint(controller ? .red : .blue)
    }
}

#Preview {
    LabelButton(controller: .constant(false), removeAction: {})
}
