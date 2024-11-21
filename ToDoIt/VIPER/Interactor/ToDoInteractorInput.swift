//
//  TodoInteractorInput.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import Foundation

protocol ToDoInteractorInput: AnyObject {
    
    func fetchTodos()
    func addTodo(_ todo: ToDo)
    func updateTodo(_ todo: ToDo)
    func deleteTodo(_ todo: ToDo)
    func searchTodos(with query: String)
    
}
