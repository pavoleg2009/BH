//
//  User.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 10/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

struct User {
    
    // MARK: Public properties
    
    let id: Int
    let name: String
    let username: String?
    let email: String?
}

extension User {
    
    // MARK: Public methods
    
    static func empty() -> User {
        return User(id: 0, name: "", username: "", email: "")
    }
}

extension User {
    
    // MARK: Lifecycle
    
    init(with apiUser: APIUser) {
        
        id = apiUser.id
        name = apiUser.name
        username = apiUser.username
        email = apiUser.email
    }
}

extension User: DatabaseConvertible {
    
    typealias DatabaseType = DBUser
    
    // MARK: Public methods
    
    func databaseModel() -> DBUser {
        
        let dbUser = DBUser()
        dbUser.id = id
        dbUser.name = name
        dbUser.username = username
        dbUser.email = email
        
        return dbUser
    }
}
