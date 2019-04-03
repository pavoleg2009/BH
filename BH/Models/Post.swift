//
//  Post.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 10/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

struct Post {
    
    // MARK: Public properties
    
    let id: Int
    let title: String
    let body: String?
    let user: User
}

extension Post {
    
    // MARK: Lifecycle
    
    init(with apiPost: APIPost, and user: User) {
        
        id = apiPost.id
        title = apiPost.title
        body = apiPost.body
        self.user = user
    }
}

extension Post: DatabaseConvertible {
    
    typealias DatabaseType = DBPost
    
    // MARK: Public methods
    
    func databaseModel() -> DBPost {
        
        let dbPost = DBPost()
        dbPost.id = id
        dbPost.title = title
        dbPost.body = body
        dbPost.user = user.databaseModel()
        
        return dbPost
    }
}
