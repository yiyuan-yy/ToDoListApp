//
//  ToDoManager.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import Foundation

class ToDoManager: ObservableObject{
    @Published var tasks: [Task] = ToDoManager.example
    @Published var showAlert = false
    @Published var alertMessage: String = ""
    
    // MARK: - Group tasks in sections by status type
    // tasks data grouped
    func groupedTask (_ status: StatusType)-> [Task] {
        return tasks.filter{$0.status == status}
    }
    
    // section expanded status
    @Published var expanded: [StatusType: Bool] = {
        var dict = [StatusType: Bool]()
        for status in StatusType.allCases {
            dict[status] = true // all expanded by default
        }
        return dict
    } ()
    
    // function to toggle expanded status
    func toggleExpanded(_ status: StatusType) {
        expanded[status]?.toggle()
    }

    
    // MARK: - Manage status of a task
    func switchStatus(_ task: Task){
        var newStatus: StatusType = .todo
        switch task.status {
        case .todo:
            newStatus = .doing
        case .doing:
            newStatus = .done
        case .done:
            newStatus = .todo
        }
        if let index = tasks.firstIndex(of: task){
            tasks[index].status = newStatus
        }
    }
    
    // MARK: - CREATE
    @Published var showCreateSheet = false
    
    private func validate(_ new: Task) ->Bool {
        // check if title is empty or less than 2 characters
        if new.title.count <= 2{
            showAlert = true
            alertMessage = "Title is empty or too short!"
            return false
        } else {
            return true
        }
    }
    
    func createToDo(_ new: Task){
        if validate(new){
            tasks.append(new)
            showCreateSheet = false
        }
    }
    
    // MARK: - Upate
    func update(old: Task, new: Task) -> Bool {
        if let index = tasks.firstIndex(of: old){
            if validate(new){
                tasks[index] = new
                return true
            }
        }
        return false
    }
    
    // MARK: - Delete
    func delete(at indexSet: IndexSet, by status: StatusType){
        let filteredTasks = groupedTask(status)
        for index in indexSet{
            if let index = tasks.firstIndex(of: filteredTasks[index] ){
                tasks.remove(at:index)
            }
        }
    }
}


extension ToDoManager{
    static var example: [Task] = [
        Task(title: "eat an apple"),
        Task(title: "finish section 21", priority: .urgent),
        Task(title: "play with baobao", priority: .optional)
    ]
}
