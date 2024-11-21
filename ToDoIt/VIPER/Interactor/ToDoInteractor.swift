//
//  ToDoInteractor.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import Foundation

final class ToDoInteractor: ToDoInteractorInput {
    weak var output: ToDoInteractorOutput?
    
    private let apiService = NetworkManager()
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Fetch Todos
    
    func fetchTodos() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                if !self.defaults.bool(forKey: "isDataLoaded") {
                    print("TodoInteractor: Initial data not loaded. Loading from API...")
                    self.loadInitialData()
                } else {
                    print("TodoInteractor: Data already loaded. Fetching from CoreData.")
                }
                
                let todos = try CoreDataManager.shared.fetchAllTodos()
                print("TodoInteractor: Successfully fetched \(todos.count) todos from CoreData.")
                DispatchQueue.main.async {
                    self.output?.didFetchTodos(todos)
                }
            } catch {
                print("TodoInteractor: Failed to fetch todos from CoreData. Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.output?.didFailWithError(error)
                }
            }
        }
    }
    
    // MARK: - Load Initial Data
    
    private func loadInitialData() {
        print("TodoInteractor: Starting to load initial data from API...")
        apiService.fetchTodos { result in
            switch result {
            case .success(let todos):
                print("TodoInteractor: Fetched \(todos.count) todos from API. Saving to CoreData...")
                for todo in todos {
                    do {
                        try CoreDataManager.shared.addTodo(todo)
                        print("TodoInteractor: Saved todo with id \(todo.id) to CoreData.")
                    } catch {
                        print("TodoInteractor: Failed to save todo with id \(todo.id) to CoreData. Error: \(error.localizedDescription)")
                    }
                }
                
                self.defaults.set(true, forKey: "isDataLoaded")
                print("TodoInteractor: Initial data successfully loaded and saved to CoreData.")
                
                self.fetchTodos()
                
            case .failure(let error):
                print("TodoInteractor: Failed to load data from API. Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Add Todo
    
    func addTodo(_ todo: ToDo) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try CoreDataManager.shared.addTodo(todo)
                print("TodoInteractor: Successfully added todo with id \(todo.id).")
                self.fetchTodos()
            } catch {
                print("TodoInteractor: Failed to add todo with id \(todo.id). Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.output?.didFailWithError(error)
                }
            }
        }
    }
    
    // MARK: - Update Todo
    
    func updateTodo(_ todo: ToDo) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try CoreDataManager.shared.updateTodo(todo)
                print("TodoInteractor: Successfully updated todo with id \(todo.id).")
                self.fetchTodos()
            } catch {
                print("TodoInteractor: Failed to update todo with id \(todo.id). Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.output?.didFailWithError(error)
                }
            }
        }
    }
    
    // MARK: - Delete Todo
    
    func deleteTodo(_ todo: ToDo) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try CoreDataManager.shared.deleteTodo(todo)
                print("TodoInteractor: Successfully deleted todo with id \(todo.id).")
                self.fetchTodos()
            } catch {
                print("TodoInteractor: Failed to delete todo with id \(todo.id). Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.output?.didFailWithError(error)
                }
            }
        }
    }
    
    // MARK: - Search Todos
    
    func searchTodos(with query: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let todos = try CoreDataManager.shared.fetchAllTodos()
                let filteredTodos = todos.filter {
                    $0.title.lowercased().contains(query.lowercased()) ||
                    $0.description.lowercased().contains(query.lowercased())
                }
                print("TodoInteractor: Found \(filteredTodos.count) todos matching query '\(query)'.")
                DispatchQueue.main.async {
                    self.output?.didFetchTodos(filteredTodos)
                }
            } catch {
                print("TodoInteractor: Failed to search todos. Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.output?.didFailWithError(error)
                }
            }
        }
    }
}
