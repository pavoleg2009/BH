//
//  APIUser.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 10/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

struct APIUser {
    
    // MARK: Public properties
    
	let id: Int
	let name: String
	let username: String?
	let email: String?
	let address: APIAddress?
	let phone: String?
	let website: String?
	let company: APICompany?
}

extension APIUser: Codable {
    
    // MARK: Public data structures
    
    enum CodingKeys: String, CodingKey {
        case id, name, username, email, address, phone, website, company
    }
    
    
    // MARK: Lifecycle
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        address = try values.decodeIfPresent(APIAddress.self, forKey: .address)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        website = try values.decodeIfPresent(String.self, forKey: .website)
        company = try values.decodeIfPresent(APICompany.self, forKey: .company)
    }
}

extension APIUser: Requestable {
    
    static var endpoint: ApiEndpoint {
        return ApiEndpoint.users
    }
}
