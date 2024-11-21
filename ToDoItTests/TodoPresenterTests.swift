//
//  TodoPresenterTests.swift
//  ToDoTests
//
//  Created by Daria Kobeleva on 20.11.2024.
//

import XCTest
@testable import ToDoIt

class TodoPresenterTests: XCTestCase {
    var presenter: ToDoPresenter!
    var mockView: MockView!
    var mockInteractor: MockInteractor!
    
    override func setUp() {
        super.setUp()
        presenter = ToDoPresenter()
        mockView = MockView()
        mockInteractor = MockInteractor()
        presenter.view = mockView
        presenter.interactor = mockInteractor
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockInteractor.fetchTodosCalled, "Presenter should call fetchTodos on interactor.")
    }
    
    func testAddNewTodo() {
        let todo = ToDo(id: UUID(), title: "Test Task", description: "Test Description", currentDate: Date(), isCompleted: false)
        presenter.addNewTodo(todo)
        XCTAssertTrue(mockInteractor.addTodoCalled, "Presenter should call addTodo on interactor.")
    }
}

// Mock View
class MockView: TodoViewProtocol {
    var displayTodosCalled = false
    var displayErrorCalled = false
    
    func displayTodos(_ todos: [ToDo]) {
        displayTodosCalled = true
    }
    
    func displayError(_ error: Error) {
        displayErrorCalled = true
    }
}

// Mock Interactor
class MockInteractor: ToDoInteractorInput {
    var fetchTodosCalled = false
    var addTodoCalled = false
    
    func fetchTodos() {
        fetchTodosCalled = true
    }
    
    func addTodo(_ todo: ToDo) {
        addTodoCalled = true
    }
    
    func updateTodo(_ todo: ToDo) {}
    func deleteTodo(_ todo: ToDo) {}
    func searchTodos(with query: String) {}
}
