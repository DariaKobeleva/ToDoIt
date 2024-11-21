//
//  TodoInteractorOutput.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import Foundation

protocol ToDoInteractorOutput: AnyObject {
    
    func didFetchTodos(_ todos: [ToDo])
    func didFailWithError(_ error: Error)
    
}
