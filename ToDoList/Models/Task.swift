//
//  Task.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import Foundation
import SwiftUICore

struct Task: Identifiable, Equatable, Hashable{
    let id: UUID = UUID()
    var title: String = ""
    var description: String = ""
    var priority: PriorityType? = nil
    var ddl: Date? = nil
    var status: StatusType = .todo
}
