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
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
        }
        .background(.darkGreenC)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.top,10)
    }
}
