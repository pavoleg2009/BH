//
//  APIPost.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 10/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

struct APIPost {
	
    // MARK: Public properties
    
    let id: Int
    let userId: Int
	let title: String
	let body: String?
}

extension APIPost: Codable  {
    
    // MARK: Public data structures
    
    enum CodingKeys: String, CodingKey {
        case id, userId, title, body
    }
    
    
    // MARK: Lifecycle
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decode(Int.self, forKey: .userId)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        body = try values.decodeIfPresent(String.self, forKey: .body)
    }
}

extension APIPost: Requestable {
    
    static var endpoint: ApiEndpoint {
        return ApiEndpoint.posts
    }
}
