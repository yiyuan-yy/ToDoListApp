//
//  SectionView.swift
//  ToDoList
//
//  Created by yiyuan hu on 11/21/25.
//

import SwiftUI

struct SectionView: View {
    let section: TaskSection
    @EnvironmentObject var viewModel: ToDoManager
    
    var body: some View {
        VStack {
            sectionHeader
            if section.expanded == true {
                ForEach(section.tasks){task in
                    TaskInListView(task: task, section: section)
                        .listRowSeparator(.hidden)
                    //                    .draggable(task.id.uuidString)
                }
                .onMove{ indexSet, destination in
                    viewModel.moveTaskInSection(from: indexSet, to: destination, in: section)
                }
                .onDelete { indexSet in
                    viewModel.delete(at: indexSet, in: section)
                }
            }
            if section.showEditingField == true {
                AddTaskField(section: section)
            }
            
            createTaskButton
        }
    }
    
    private var sectionHeader: some View{
        HStack {
            Text(section.id.name)
            Button {
                withAnimation(.spring) {
                    viewModel.toggleExpanded(section)
                }
            } label: {
                Image(systemName:  "chevron.down")
                    .font(.caption)
                    .rotationEffect(section.expanded == true ? .degrees(0) : .degrees(-90))
            }
            .buttonStyle(.borderless)
        }
    }
    
    private var createTaskButton: some View{
        Button {
            withAnimation(.spring) {
                viewModel.toggleEditingField(in: section)
            }
        } label: {
            Image(systemName: section.showEditingField ? "minus" : "plus")
                .font(section.expanded ? .body : .footnote)
                .frame(maxWidth: .infinity)
                .frame(height: 20)
        }
        .buttonStyle(.borderless)
    }
}
