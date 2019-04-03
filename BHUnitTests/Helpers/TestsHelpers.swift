//
//  TestsHelpers.swift
//  BHUnitTests
//
//  Created by Oleg Pavlichenkov on 06/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
@testable import BH

struct TestsHelper {
    
    // MARK: Public properties
    
    static var users: [User] {
        return [
            User(id: 0, name: "user0", username: "user name 0", email: "user0@mail.com"),
            User(id: 1, name: "user1", username: "user name 1", email: "user1@mail.com")
        ]
    }
    
    static var posts: [Post] {
        
        return [
            Post(id: 1, title: "post title 1", body: "post #1 of user 0 body", user: users[0]),
            Post(id: 2, title: "post title 2", body: "post #2 of yser 1 body", user: users[1]),
            Post(id: 3, title: "post title 3", body: "post #2 of user 0 body", user: users[0])
        ]
    }
    
    static var comments: [Comment] {
        
        return [
            Comment(postId: 1, id: 1, name: "id labore ex et quam laborum", email: "Eliseo@gardner.biz", body: "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"),
            Comment(postId: 1, id: 2, name: "quo vero reiciendis velit similique earum", email: "Jayne_Kuhic@sydney.com", body: "est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et"),
            Comment(postId: 1, id: 3, name: "odio adipisci rerum aut animi", email: "Nikita@garfield.biz", body: "quia molestiae reprehenderit quasi aspernatur\naut expedita occaecati aliquam eveniet laudantium\nomnis quibusdam delectus saepe quia accusamus maiores nam est\ncum et ducimus et vero voluptates excepturi deleniti ratione")
        ]
    }
}
