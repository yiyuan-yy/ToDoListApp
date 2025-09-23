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
    
    // MARK: - Computed properties
    var formattedDDL: String?{
        if let ddl = self.ddl{
            let calendar = Calendar.current
            
            if calendar.isDateInToday(ddl){
                return "Today"
            }
            
            if calendar.isDateInTomorrow(ddl){
                return "Tomorrow"
            }
            
            if calendar.isDateInYesterday(ddl){
                return "Yesterday"
            }
            
            return ddl.formatted(date: .abbreviated, time: .omitted)
        }
        return nil
    }
    
    
    var isInToday: Bool{
        let calendar = Calendar.current
        
        if let ddl = self.ddl{
            if calendar.isDateInToday(ddl){
                return true
            }
            else{
                return false
            }
        }
        return false
    }
    
    var ddlImg: String {
        if let ddl = self.ddl {
            if status != .done{
                if isInToday {
                    return "clock"
                }
                if ddl < Date(){
                    return "clock.badge.exclamationmark"
                } else {
                    return "clock"
                }
            } else {
                return "clock.badge.checkmark"
            }
        }
        return "clock.badge.checkmark"
       
    }
    
    var ddlColor: Color{
        if let ddl = self.ddl {
            if status != .done{
                if isInToday {
                    return Color.blue
                }
                if ddl <= Date(){
                    return Color.red
                } else {
                    return Color.gray
                }
            } else {
                return Color.gray
            }
        }
        return Color.gray
    }
}
