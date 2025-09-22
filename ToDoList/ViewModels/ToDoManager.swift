//
//  ToDoManager.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import Foundation

class ToDoManager: ObservableObject{
    @Published var tasksBySection: [TaskSection] = ToDoManager.example
    @Published var showAlert = false
    @Published var alertMessage: String = ""
    @Published var showCreateSheet = false

    // switch tasks section expanded or not
    func toggleExpanded(_ target: TaskSection){
        if let index = tasksBySection.firstIndex(of: target){
            tasksBySection[index].expanded.toggle()
        }
    }

    // MARK: - Manage status of a task
    func switchTaskStatus(_ task: Task, in section: TaskSection){
        let newStatus = task.status.nextStatus
        var updatedTask = task
        updatedTask.status = newStatus
        // Remove old task
        if !remove(task) || !add(updatedTask){
            return
        }
    }
    
    // MARK: - CREATE
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
    
    func createToDo(_ newTask: Task){
        if validate(newTask){
            if let index = sectionIndex(of: newTask.status){
                tasksBySection[index].tasks.append(newTask)
                showCreateSheet = false
            }
        }
    }
    
    // MARK: - Upate
    func update(old: Task, new: Task) -> Bool {
        // remove old task
        if !validate(new) {return false}
        if remove(old) && add(new){
            return true
        }
        return false
    }
    
    // MARK: - Delete
    func delete(at indexSet: IndexSet, in section: TaskSection){
        guard let indexS = sectionIndex(of: section) else {return}
        tasksBySection[indexS].tasks.remove(atOffsets: indexSet)
    }
    
    //MARK: - Drag and Move
    func moveTaskInSection(from source: IndexSet, to destination: Int, in section: TaskSection) {
        guard let sectionIndex = self.sectionIndex(of: section) else {return}
        tasksBySection[sectionIndex].tasks.move(fromOffsets: source, toOffset: destination)
    }
    
}


extension ToDoManager{
    // MARK: - data example
    static let example: [TaskSection] = [
        TaskSection(id: .todo, tasks: [
            Task(title: "Buy milk", priority: .normal, status: .todo),
            Task(title: "Call Bob", status: .todo)
        ]),
        TaskSection(id: .doing, tasks: [
            Task(title: "Write report", priority: .urgent, status: .doing)
        ]),
        TaskSection(id: .done, tasks: [
            Task(title: "Pay bill", status: .done)
        ])
    ]
    
    static let empty: [TaskSection] = StatusType.allCases.map{ TaskSection(id: $0) }
    
    
    // MARK: - helpers
    private func sectionIndex(of status: StatusType) -> Int?{
        guard let index = tasksBySection.firstIndex(where: {$0.id == status}) else {return nil}
        return index
    }
    
    private func sectionIndex(of task: Task) -> Int?{
        guard let index = tasksBySection.firstIndex(where: {$0.id == task.status}) else {return nil}
        return index
    }
    
    private func sectionIndex(of section: TaskSection) -> Int?{
        guard let index = tasksBySection.firstIndex(of: section) else {return nil}
        return index
    }
    
    private func taskIndex(of task: Task) -> Int?{
        guard let sectionIndex = self.sectionIndex(of: task) else {return nil}
        guard let taskIndex = tasksBySection[sectionIndex].tasks.firstIndex(of: task) else {return nil}
        return taskIndex
    }
    
    private func remove(_ task: Task) -> Bool {
        guard let oldSectionIndex = sectionIndex(of: task.status) else {return false}
        guard let taskIndex = taskIndex(of: task) else {return false}
        tasksBySection[oldSectionIndex].tasks.remove(at: taskIndex)
        return true
    }
    
    private func add(_ newTask: Task) -> Bool {
        guard let newSectionIndex = sectionIndex(of: newTask) else {return false}
        tasksBySection[newSectionIndex].tasks.append(newTask)
        return true
    }
}
