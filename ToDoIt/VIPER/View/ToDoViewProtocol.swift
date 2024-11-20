//
//  ToDoViewProtocol.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import Foundation

protocol TodoViewProtocol: AnyObject {
    
    func displayTodos(_ todos: [Todo])
    
    func displayError(_ error: Error)
    
}
