//
//  TodoPresenter .swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import Foundation

final class TodoPresenter {
    
    weak var view: TodoViewProtocol?
    
    var interactor: TodoInteractorInput?
    
    var router: TodoRouterProtocol?
    
    private var todos: [Todo] = []
    
    // MARK: - View Lifecycle

    func viewDidLoad() {
        print("TodoPresenter: View did load.")
        interactor?.fetchTodos()
    }
    
    // MARK: - Add Todo

    func addNewTodo(_ todo: Todo) {
        print("TodoPresenter: Adding new todo with title \(todo.title).")
        interactor?.addTodo(todo)
    }
    
    // MARK: - Update Todo
    
    func updateExistingTodo(_ todo: Todo) {
        print("TodoPresenter: Updating todo with id \(todo.id).")
        interactor?.updateTodo(todo)
    }
    
    // MARK: - Delete Todo
    
    func deleteExistingTodo(_ todo: Todo) {
        print("TodoPresenter: Deleting todo with id \(todo.id).")
        interactor?.deleteTodo(todo)
    }
    
    // MARK: - Search Todos
    
    func searchTodos(with query: String) {
        print("TodoPresenter: Searching todos with query '\(query)'.")
        interactor?.searchTodos(with: query)
    }
}

// MARK: - TodoInteractorOutput

extension TodoPresenter: TodoInteractorOutput {

    func didFetchTodos(_ todos: [Todo]) {
        print("TodoPresenter: Fetched \(todos.count) todos.")
        self.todos = todos
        view?.displayTodos(todos)
    }

    func didFailWithError(_ error: Error) {
        print("TodoPresenter: Encountered error - \(error.localizedDescription).")
        view?.displayError(error)
    }
    
}
