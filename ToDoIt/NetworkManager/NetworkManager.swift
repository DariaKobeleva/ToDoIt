//
//  NetworkManager.swift
//  ToDoIt
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import Foundation

final class NetworkManager {
    
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            print("TodoAPIService: Invalid URL.")
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        print("NeteorkManager: Starting request to \(url).")

        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                print("NeteorkManager: Request failed with error: \(error.localizedDescription).")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("NeteorkManager: No data received.")
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            print("NeteorkManager: Data received. Decoding...")

            do {
                let response = try JSONDecoder().decode(TodoAPIResponse.self, from: data)

                let todos = response.todos.map { apiTodo in
                    Todo(
                        id: UUID(),
                        title: apiTodo.todo,
                        description: "Imported Task",
                        currentDate: Date(),
                        isCompleted: apiTodo.completed
                    )
                }

                print("NeteorkManager: Successfully decoded \(todos.count) todos.")

                completion(.success(todos))
            } catch {
                print("NeteorkManager: Decoding failed with error: \(error.localizedDescription).")
                completion(.failure(error))
            }
        }.resume()
    }
    
}
