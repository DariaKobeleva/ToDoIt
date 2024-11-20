//
//  TodoInteractorInput.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import Foundation

protocol TodoInteractorInput: AnyObject {
    
    func fetchTodos()
    func addTodo(_ todo: Todo)
    func updateTodo(_ todo: Todo)
    func deleteTodo(_ todo: Todo)
    func searchTodos(with query: String)
    
}
