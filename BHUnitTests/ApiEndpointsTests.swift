//
//  ApiEndpointsTests.swift
//  BHAsyncTests
//
//  Created by Oleg Pavlichenkov on 01/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import XCTest
@testable import BH

class ApiEndpointsTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_RequestToPosts_ShouldReturn100Posts() {
        
        // Assert
        var posts = [APIPost]()
        let promise = expectation(description: "Request should complete")
        
        // Act
        let url = ApiEndpoint.posts.url()
        
        // Assert
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data else {
                    XCTFail("Wrong response from ApiEndpoints.posts")
                    return
            }
            
            posts = (try? JSONDecoder().decode([APIPost].self, from: data)) ?? []
            
            promise.fulfill()
        }
        dataTask.resume()
        
        wait(for: [promise], timeout: 2)
        
        XCTAssertEqual(posts.count, 100)
    }
    
    func test_RequestToUsers_ShouldReturn10Users() {
        
        // Assert
        var users = [APIUser]()
        let promise = expectation(description: "Request should complete")
        
        // Act
        let url = ApiEndpoint.users.url()
        
        // Assert
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data else {
                    XCTFail("Wrong response from ApiEndpoints.users")
                    return
            }
            
            users = (try? JSONDecoder().decode([APIUser].self, from: data)) ?? []
            
            promise.fulfill()
        }
        dataTask.resume()
        
        wait(for: [promise], timeout: 2)
        
        XCTAssertEqual(users.count, 10)
    }
    
    func test_RequestToComments_ShouldReturn500Comments() {
        
        // Assert
        var comments = [APIComment]()
        let promise = expectation(description: "Request should complete")
        
        // Act
        let url = ApiEndpoint.comments.url()
        
        // Assert
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data else {
                    XCTFail("Wrong response from ApiEndpoints.comments")
                    return
            }
            
            comments = (try? JSONDecoder().decode([APIComment].self, from: data)) ?? []
            
            promise.fulfill()
        }
        dataTask.resume()
        
        wait(for: [promise], timeout: 2)
        
        XCTAssertEqual(comments.count, 500)
    }

}
