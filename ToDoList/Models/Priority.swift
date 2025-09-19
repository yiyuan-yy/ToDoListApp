//
//  PriorityType.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/19/25.
//
import Foundation
import SwiftUICore

enum PriorityType: Int, CaseIterable, Identifiable{
    case normal, urgent, optional
    
    var id: Self {return self}
    
    var name: String {
        switch self {
        case .normal:
            return "Normal"
        case .urgent:
            return "Urgent"
        case .optional:
            return "Optional"
        }
    }
    var backgroundColor: Color{
        switch self {
        case .normal:
            return Color.lightGreenC
        case .urgent:
            return Color.lightRedC
        case .optional:
            return Color.lightBlueC
        }
    }
    
    var textColor: Color{
        switch self {
        case .normal:
            return Color.darkGreenC
        case .urgent:
            return Color.red
        case .optional:
            return Color.blue
        }
    }
}
