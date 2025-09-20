//
//  Status.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/19/25.
//

import Foundation

// MARK: - Status Type
enum StatusType: CaseIterable, Identifiable {
    case todo, doing, done
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .todo:  return "To Do"
        case .doing: return "Doing"
        case .done:  return "Done"
        }
    }
    
    var imgName: String {
        switch self {
        case .todo:  return "circle"
        case .doing: return "minus.circle.fill"
        case .done:  return "checkmark.circle.fill"
        }
    }
    
    var nextStatus: StatusType {
        switch self {
        case .todo:
            return .doing
        case .doing:
            return .done
        case .done:
            return .todo
        }
    }
}


