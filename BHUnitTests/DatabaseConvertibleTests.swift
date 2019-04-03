//
//  DatabaseConvertibleTests.swift
//  BHUnitTests
//
//  Created by Oleg Pavlichenkov on 05/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import XCTest
@testable import BH

class DatabaseConvertibleTests: XCTestCase {

    func test_userToDatabaseModel() {
        
        // Arrange
        let user = User(id: 123, name: "user", username: "username", email: "e@mail.com")
        
        // Act
        let dbUser = user.databaseModel()
        
        // Assert
        XCTAssertEqual(dbUser.id, user.id)
        XCTAssertEqual(dbUser.name, user.name)
        XCTAssertEqual(dbUser.username, user.username)
        XCTAssertEqual(dbUser.email, user.email)
    }
    
    func test_DBuserToDomainModel() {
        
        // Arrange
        let dbUser = DBUser()
        dbUser.id = -1
        dbUser.name = "name"
        dbUser.username = "username"
        dbUser.email = "e@mail.com"

        // Act
        let user = dbUser.domainModel()
        
        // Assert
        XCTAssertEqual(user.id, -1)
        XCTAssertEqual(user.name, "name")
        XCTAssertEqual(user.username, "username")
        XCTAssertEqual(user.email, "e@mail.com")
    }
    
    func test_postToDatabaseModel() {

        // Arrange
        let user = User(id: 123, name: "user", username: "username", email: "e@mail.com")
        let post = Post(id: 999, title: "testTitle", body: "testBody", user: user)
        
        // Act
        let dbPost = post.databaseModel()
        
        // Assert
        XCTAssertEqual(dbPost.id, post.id)
        XCTAssertEqual(dbPost.title, post.title)
        XCTAssertEqual(dbPost.body, post.body)
        XCTAssertEqual(dbPost.user?.id, post.user.id)
    }

    func test_DBPostToDomainModel() {
        
        // Arrange
        let dbUser = DBUser()
        dbUser.id = -1
        dbUser.name = "name"
        dbUser.username = "username"
        dbUser.email = "e@mail.com"
        
        let dbPost = DBPost()
        dbPost.id = 123
        dbPost.title = "title"
        dbPost.body = "body"
        dbPost.user = dbUser
        
        // Act
        let post = dbPost.domainModel()
        
        // Assert
        XCTAssertEqual(post.id, 123)
        XCTAssertEqual(post.title, "title")
        XCTAssertEqual(post.body, "body")
        XCTAssertEqual(post.user.id, -1)
    }
}
