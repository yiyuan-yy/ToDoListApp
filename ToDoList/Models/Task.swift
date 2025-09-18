//
//  Task.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import Foundation
import SwiftUICore

struct Task: Identifiable, Equatable{
    let id: UUID = UUID()
    var title: String = ""
    var priority: PriorityType = .normal
    var ddl: Date? = nil
    var status: StatusType = .todo
    
    enum PriorityType: Int, CaseIterable, Identifiable{
        case normal, urgent, optional
        
        var id: Self{
            self
        }
        
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
    
    enum StatusType: Int, CaseIterable{
        case todo, doing, done
        
        var name: String{
            switch self {
            case .todo:
                return "To Do"
            case .doing:
                return "Doing"
            case .done:
                return "Done"
            }
        }
        
        var imgName: String{
            switch self {
            case .todo:
                return "circle"
            case .doing:
                return "minus.circle"
            case .done:
                return "checkmark.circle"
            }
        }
    }
}
