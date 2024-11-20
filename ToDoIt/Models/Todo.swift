//
//  Todo.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import Foundation

struct Todo {
    
    let id: UUID
    let title: String
    let description: String
    let currentDate: Date
    let isCompleted: Bool
    
    init(from entity: ToDoTask) {
        id = entity.id ?? UUID()
        title = entity.title ?? "Untitled"
        description = entity.taskDescription ?? "No description"
        currentDate = entity.date ?? Date()
        isCompleted = entity.isCompleted
    }
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        currentDate: Date = Date(),
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.currentDate = currentDate
        self.isCompleted = isCompleted
    }
    
}
