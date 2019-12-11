//
//  ApiEndpoints.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 01/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

enum ApiEndpoint {
    
    case posts, users, comments
    
    func url() -> URL {
        // swiftlint:disable force_unwrapping
        switch self {
        case .posts:
            return URL(string: "http://jsonplaceholder.typicode.com/posts")!
        case .users:
            return URL(string: "http://jsonplaceholder.typicode.com/users")!
        case .comments:
            return URL(string: "http://jsonplaceholder.typicode.com/comments")!
        }
        // swiftlint:enabe force_unwrapping
    }
}
