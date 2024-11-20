//
//  CoreDataManager.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import CoreData
import Foundation

final class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoIt")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Core Data Operations

    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
            print("CoreDataManager: Changes saved successfully.")
        } catch {
            print("CoreDataManager: Failed to save context: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch Operations

    func fetchAllTodos() throws -> [Todo] {
        let request: NSFetchRequest<ToDoTask> = ToDoTask.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        do {
            let toDoTask = try context.fetch(request)
            print("CoreDataManager: Fetched \(toDoTask.count) todos.")
            return toDoTask.map { Todo(from: $0) }
        } catch {
            print("CoreDataManager: Failed to fetch todos: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Add Operations

    func addTodo(_ task: Todo) throws {
        let entity = ToDoTask(context: context)
        entity.id = task.id
        entity.title = task.title
        entity.taskDescription = task.description
        entity.date = task.currentDate
        entity.isCompleted = task.isCompleted
        saveContext()
    }

    // MARK: - Update Operations

    func updateTodo(_ task: Todo) throws {
        let request: NSFetchRequest<ToDoTask> = ToDoTask.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id.uuidString)

        do {
            guard let entity = try context.fetch(request).first else {
                print("CoreDataManager: Todo not found with id \(task.id).")
                throw NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"])
            }
            entity.title = task.title
            entity.taskDescription = task.description
            entity.isCompleted = task.isCompleted
            saveContext()
            print("CoreDataManager: Updated todo with id \(task.id).")
        } catch {
            print("CoreDataManager: Failed to update todo: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Delete Operations

    func deleteTodo(_ task: Todo) throws {
        let request: NSFetchRequest<ToDoTask> = ToDoTask.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id.uuidString)

        do {
            guard let entity = try context.fetch(request).first else {
                print("CoreDataManager: Todo not found with id \(task.id).")
                throw NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"])
            }
            context.delete(entity)
            saveContext()
            print("CoreDataManager: Deleted todo with id \(task.id).")
        } catch {
            print("CoreDataManager: Failed to delete todo: \(error.localizedDescription)")
            throw error
        }
    }
}
