//
//  APIComment.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 10/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

struct APIComment {
    
    // MARK: Public properties
    
	let postId: Int
	let id: Int
	let name: String?
	let email: String?
	let body: String?
}

extension APIComment: Codable {
    
    // MARK: Public data structures
    
	enum CodingKeys: String, CodingKey {
		case postId, id, name, email, body
	}

    // MARK: Lifecycle
    
	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		postId = try values.decode(Int.self, forKey: .postId)
		id = try values.decode(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		body = try values.decodeIfPresent(String.self, forKey: .body)
	}
}

extension APIComment: Requestable {
    
    static var endpoint: ApiEndpoint {
        return ApiEndpoint.comments
    }
}
