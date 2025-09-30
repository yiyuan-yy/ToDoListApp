//
//  ToDoManager.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/18/25.
//

import Foundation

class ToDoManager: ObservableObject{
    
    // MARK: - Boards
    @Published var boards: [Board] = [
        Board(name: "Personal",sections: Board.example),
        Board(name: "Work", sections: Board.exampleWork),
        Board(name: "Study", sections: Board.exampleStudy),
    ]
    
    @Published var currentBoardIndex: Int = 0
    
    func switchToBoard(to board: Board){
        if let boardIndex = boards.firstIndex(of: board){
            currentBoardIndex = boardIndex
        }
    }
    
    func addNewBoard(name: String){
        boards.append(Board(name: name))
        currentBoardIndex = boards.count - 1
    }
    
    // Computed variables of boards
    var currentSections: [TaskSection] {
        if currentBoardIndex < boards.count {
            return boards[currentBoardIndex].sections
        } else {
            return []
        }
    }
    
    var currentBoardName: String{
        if currentBoardIndex < boards.count {
            return boards[currentBoardIndex].name
        } else {
            return "Tasks"
        }
    }
    
    
    // MARK: - Tasks
    @Published var showAlert = false
    @Published var alertMessage: String = ""
    @Published var showCreateSheet = false
    
    @Published var taskToEdit: Task? = nil
    @Published var showFullLabel = false
    
    private func remove(_ task: Task) -> Bool {
        guard let oldSectionIndex = sectionIndex(of: task.status) else {return false}
        guard let taskIndex = taskIndex(of: task) else {return false}
        boards[currentBoardIndex].sections[oldSectionIndex].tasks.remove(at: taskIndex)
        return true
    }
    
    private func add(_ newTask: Task) -> Bool {
        guard let newSectionIndex = sectionIndex(of: newTask) else {return false}
        boards[currentBoardIndex].sections[newSectionIndex].tasks.append(newTask)
        return true
    }

    // MARK: - Manage section behaviors
    // switch tasks section expanded or not
    func toggleExpanded(_ target: TaskSection){
        if let index = sectionIndex(of: target){
            boards[currentBoardIndex].sections[index].expanded.toggle()
        }
    }
    
    func toggleEditingField(in section: TaskSection){
        if let index = sectionIndex(of: section){
            boards[currentBoardIndex].sections[index].showEditingField.toggle()
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
    
    func createToDoInSection(_ newTask: Task, in section: TaskSection) -> Bool {
        var newTask = newTask
        newTask.status = section.id
        if validate(newTask){
            if let index = sectionIndex(of: section){
                boards[currentBoardIndex].sections[index].tasks.append(newTask)
                boards[currentBoardIndex].sections[index].showEditingField = false
                return true
            }
        }
        return false
    }
    
    // MARK: - Upate
    func update(old: Task, new: Task) -> Bool {
        // remove old task
        if !validate(new) {return false}
        if new.status != old.status{
            if remove(old) && add(new){
                return true
            }
        } else {
            guard let sectionIndex = self.sectionIndex(of: old) else {return false}
            guard let taskIndex = self.taskIndex(of: old) else {return false}
            boards[currentBoardIndex].sections[sectionIndex].tasks[taskIndex] = new
            return true
        }
        
        return false
    }
    
    // MARK: - Delete
    func delete(at indexSet: IndexSet, in section: TaskSection){
        guard let indexS = sectionIndex(of: section) else {return}
        boards[currentBoardIndex].sections[indexS].tasks.remove(atOffsets: indexSet)
    }
    
    //MARK: - Drag and Move
    func moveTaskInSection(from source: IndexSet, to destination: Int, in section: TaskSection) {
        guard let sectionIndex = self.sectionIndex(of: section) else {return}
        boards[currentBoardIndex].sections[sectionIndex].tasks.move(fromOffsets: source, toOffset: destination)
    }
    
}

extension ToDoManager{
    // MARK: - helpers
    private func sectionIndex(of status: StatusType) -> Int?{
        guard let index = currentSections.firstIndex(where: {$0.id == status}) else {return nil}
        return index
    }
    
    private func sectionIndex(of task: Task) -> Int?{
        guard let index = currentSections.firstIndex(where: {$0.id == task.status}) else {return nil}
        return index
    }
    
    private func sectionIndex(of section: TaskSection) -> Int?{
        guard let index = currentSections.firstIndex(of: section) else {return nil}
        return index
    }
    
    private func taskIndex(of task: Task) -> Int?{
        guard let sectionIndex = self.sectionIndex(of: task) else {return nil}
        guard let taskIndex = currentSections[sectionIndex].tasks.firstIndex(of: task) else {return nil}
        return taskIndex
    }
}
