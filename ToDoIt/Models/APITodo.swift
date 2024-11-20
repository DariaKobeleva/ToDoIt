//
//  APITodo.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import Foundation

struct APITodo: Codable {
    
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
    
}
