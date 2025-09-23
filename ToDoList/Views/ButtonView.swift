//
//  ButtonView.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import SwiftUI

struct ButtonView: View {
    var action: ()-> Void
    var text: String
    
    var body: some View {
        Button (action: action) {
            Text(text)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
//        .tint(.darkGreenC)
        .padding(.top,10)
    }
    
    
}
