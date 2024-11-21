//
//  CoreDataManagerTests.swift
//  ToDoTests
//
//  Created by Daria Kobeleva on 20.11.2024
//

import XCTest
@testable import ToDoIt

class CoreDataManagerTests: XCTestCase {
    var coreDataManager: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
    }
    
    override func tearDown() {
        coreDataManager = nil
        super.tearDown()
    }
    
    func testAddTodo() {
        let todo = ToDo(id: UUID(), title: "Test Task", description: "Test Description", currentDate: Date(), isCompleted: false)
        
        do {
            try coreDataManager.addTodo(todo)
            let todos = try coreDataManager.fetchAllTodos()
            XCTAssertTrue(todos.contains(where: { $0.id == todo.id }), "Todo should be added to CoreData.")
        } catch {
            XCTFail("Failed to add todo: \(error.localizedDescription)")
        }
    }
    
    func testFetchTodos() {
        do {
            let todos = try coreDataManager.fetchAllTodos()
            XCTAssertNotNil(todos, "Fetched todos should not be nil.")
        } catch {
            XCTFail("Failed to fetch todos: \(error.localizedDescription)")
        }
    }
    
    func testUpdateTodo() {
        let todo = ToDo(id: UUID(), title: "Task to Update", description: "Initial Description", currentDate: Date(), isCompleted: false)
        
        do {
            try coreDataManager.addTodo(todo)
            var updatedTodo = todo
            updatedTodo.title = "Updated Title"
            try coreDataManager.updateTodo(updatedTodo)
            
            let todos = try coreDataManager.fetchAllTodos()
            XCTAssertTrue(todos.contains(where: { $0.title == "Updated Title" }), "Todo should be updated in CoreData.")
        } catch {
            XCTFail("Failed to update todo: \(error.localizedDescription)")
        }
    }
    
    func testDeleteTodo() {
        let todo = ToDo(id: UUID(), title: "Task to Delete", description: "Description", currentDate: Date(), isCompleted: false)
        
        do {
            try coreDataManager.addTodo(todo)
            try coreDataManager.deleteTodo(todo)
            let todos = try coreDataManager.fetchAllTodos()
            XCTAssertFalse(todos.contains(where: { $0.id == todo.id }), "Todo should be deleted from CoreData.")
        } catch {
            XCTFail("Failed to delete todo: \(error.localizedDescription)")
        }
    }
}
