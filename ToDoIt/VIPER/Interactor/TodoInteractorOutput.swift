//
//  TodoInteractorOutput.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import Foundation

protocol TodoInteractorOutput: AnyObject {
    
    func didFetchTodos(_ todos: [Todo])
    func didFailWithError(_ error: Error)
    
}
