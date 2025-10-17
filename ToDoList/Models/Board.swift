//
//  Palette.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/24/25.
//
import Foundation

struct Board: Identifiable, Equatable{
    var id = UUID()
    private(set) var name: String = "Personal"
    var sections: [TaskSection] = Board.empty
    
    mutating func rename(_ newName: String){
        self.name = newName
    }
}

extension Board{
    // MARK: - data example
    static let example: [TaskSection] = [
        TaskSection(id: .todo, tasks: [
            Task(title: "Buy milk", priority: .normal, ddl: Date(), status: .todo),
            Task(title: "Call Bob", status: .todo)
        ]),
        TaskSection(id: .doing, tasks: [
            Task(title: "Write diary", priority: .urgent, ddl: Date(), status: .doing)
        ]),
        TaskSection(id: .done, tasks: [
            Task(title: "Pay bill", status: .done)
        ])
    ]
    static let exampleWork: [TaskSection] = [
        TaskSection(id: .todo, tasks: [
            Task(title: "Meeting at 9 am", priority: .normal, ddl: Date(), status: .todo)
        ]),
        TaskSection(id: .doing, tasks: [
            Task(title: "Write report", priority: .urgent, ddl: Date(), status: .doing)
        ]),
        TaskSection(id: .done, tasks: [
            Task(title: "Email Alice", status: .done)
        ])
    ]
    static let exampleStudy: [TaskSection] = [
        TaskSection(id: .todo, tasks: [
            Task(title: "Learn French", priority: .normal, ddl: Date(), status: .todo)
        ]),
        TaskSection(id: .doing, tasks: [
            Task(title: "Learn English", priority: .urgent, ddl: Date(), status: .doing)
        ]),
        TaskSection(id: .done, tasks: [
            Task(title: "Read Char 18", status: .done)
        ])
    ]
    static let empty: [TaskSection] = StatusType.allCases.map{ TaskSection(id: $0) }
}
