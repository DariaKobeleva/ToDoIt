//
//  TodoAPIServiceTests.swift
//  ToDoTests
//
//  Created by Daria Kobeleva on 20.11.2024
//

import XCTest
@testable import ToDoIt

class TodoAPIServiceTests: XCTestCase {
    var apiService: NetworkManager!
    
    override func setUp() {
        super.setUp()
        apiService = NetworkManager()
    }
    
    override func tearDown() {
        apiService = nil
        super.tearDown()
    }
    
    func testFetchTodosSuccess() {
        let expectation = self.expectation(description: "Fetch Todos from API")
        
        apiService.fetchTodos { result in
            switch result {
            case .success(let todos):
                XCTAssertGreaterThan(todos.count, 0, "API should return a non-empty list of todos.")
            case .failure(let error):
                XCTFail("API call failed with error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
