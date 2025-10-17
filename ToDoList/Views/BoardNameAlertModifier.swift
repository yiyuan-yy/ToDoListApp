//
//  NameAlertModifier.swift
//  ToDoList
//
//  Created by yiyuan hu on 10/16/25.
//

import SwiftUI

struct BoardNameAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    @EnvironmentObject var viewModel: ToDoManager
    var action: ()->Void
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented, error: viewModel.boardNameError) { _ in
                Button ("OK") {
                    action()
                }
            } message: { error in
                Text("Please set another name.")
            }
        
    }
}

extension View {
    func boardNameAlert(
        isPresented: Binding <Bool>,
        action: @escaping ()->Void
    ) -> some View {
        self.modifier(BoardNameAlertModifier(isPresented: isPresented, action: action))
    }
}
