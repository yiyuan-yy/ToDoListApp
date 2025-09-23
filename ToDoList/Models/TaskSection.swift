//
//  TasksByStatus.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/20/25.
//

import Foundation

struct TaskSection: Identifiable, Hashable{
    // like a dictionary
    var id: StatusType
    var tasks: [Task] = []
    
    // control of whether the section is expanded
    var expanded: Bool = true
    
    // control of whether show the tempory editing field
    var showEditingField: Bool = false
}


