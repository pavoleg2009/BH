//
//  Comment.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 16/02/2019.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

struct Comment {
    
    // MARK: Public properties
    
    let postId: Int
    let id: Int
    let name: String?
    let email: String?
    let body: String?
}

extension Comment {
    
    // MARK: Lifecycle
    
    init(with apiComment: APIComment) {
        
        id = apiComment.id
        postId = apiComment.postId
        name = apiComment.name
        email = apiComment.email
        body = apiComment.body
    }
}

extension Comment: DatabaseConvertible {
    
    typealias DatabaseType = DBComment
    
    // MARK: Public methods
    
    func databaseModel() -> DBComment {
        
        let dbComment = DBComment()
        dbComment.postId = postId
        dbComment.id = id
        dbComment.name = name
        dbComment.email = email
        dbComment.body = body
        
        return dbComment
    }
}
