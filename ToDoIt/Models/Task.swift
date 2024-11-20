//
//  Task.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import Foundation

// MARK: - Модель Todo

/// Структура для представления задачи.
struct Task {
    /// Уникальный идентификатор задачи.
    let id: UUID
    /// Заголовок задачи.
    let title: String
    /// Описание задачи.
    let description: String
    /// Дата создания задачи.
    let date: Date
    /// Флаг завершенности задачи.
    let isCompleted: Bool
    
    /// Инициализация задачи из CoreData.
    /// - Parameter entity: Сущность CoreData.
    init(from entity: ToDoTask) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? "Untitled"
        self.description = entity.taskDescription ?? "No description"
        self.date = entity.date ?? Date()
        self.isCompleted = entity.isCompleted
    }
    
    /// Инициализация новой задачи вручную.
    /// - Parameters:
    ///   - id: Уникальный идентификатор задачи.
    ///   - title: Заголовок задачи.
    ///   - description: Описание задачи.
    ///   - createdAt: Дата создания задачи.
    ///   - isCompleted: Флаг завершенности задачи.
    init(id: UUID = UUID(), title: String, description: String, createdAt: Date = Date(), isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.date = createdAt
        self.isCompleted = isCompleted
    }
}
