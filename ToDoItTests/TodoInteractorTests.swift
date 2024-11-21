//
//  TodoInteractorTests.swift
//  ToDoTests
//
//  Created by Daria Kobeleva on 20.11.2024
//

import XCTest
@testable import ToDoIt

class TodoInteractorTests: XCTestCase {
    var interactor: ToDoInteractor!
    var mockOutput: MockInteractorOutput!
    
    override func setUp() {
        super.setUp()
        interactor = ToDoInteractor()
        mockOutput = MockInteractorOutput()
        interactor.output = mockOutput
    }
    
    override func tearDown() {
        interactor = nil
        mockOutput = nil
        super.tearDown()
    }
    
    func testFetchTodos() {
        interactor.fetchTodos()
        XCTAssertTrue(mockOutput.didFetchTodosCalled, "Interactor should call didFetchTodos on output.")
    }
    
    func testAddTodo() {
        let todo = ToDo(id: UUID(), title: "Test Add", description: "Description", currentDate: Date(), isCompleted: false)
        interactor.addTodo(todo)
        XCTAssertTrue(mockOutput.didFetchTodosCalled, "Interactor should fetch todos after adding.")
    }
}

// Mock Output
class MockInteractorOutput: ToDoInteractorOutput {
    var didFetchTodosCalled = false
    var didFailWithErrorCalled = false
    
    func didFetchTodos(_ todos: [ToDo]) {
        didFetchTodosCalled = true
    }
    
    func didFailWithError(_ error: Error) {
        didFailWithErrorCalled = true
    }
}
