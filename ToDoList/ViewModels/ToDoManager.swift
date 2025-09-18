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

    
    // switch status of a task
    func switchStatus(_ task: Task){
        var newStatus: Task.StatusType = .todo
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
    
    //Mark create task
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
    
    func update(old: Task, new: Task){
        if let index = tasks.firstIndex(of: old){
            if validate(new){
                tasks[index] = new
            }
        }
    }
    
    // Delete a task
    func delete(at indexSet: IndexSet){
        tasks.remove(atOffsets: indexSet)
    }
}


extension ToDoManager{
    static var example: [Task] = [
        Task(title: "eat an apple"),
        Task(title: "finish section 21", priority: .urgent),
        Task(title: "play with baobao", priority: .optional)
    ]
}
