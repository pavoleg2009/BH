//
//  APIComment.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 10/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

struct APIAddress {
    
    // MARK: Public properties
    
	let street: String?
	let suite: String?
	let city: String?
	let zipcode: String?
	let geo: APIGeo?
}

extension APIAddress: Codable {
    
    // MARK: Public data structures
    
    enum CodingKeys: String, CodingKey {
        case street, suite, city, zipcode, geo
    }
    
    // MARK: Lifecycle
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        street = try values.decodeIfPresent(String.self, forKey: .street)
        suite = try values.decodeIfPresent(String.self, forKey: .suite)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        zipcode = try values.decodeIfPresent(String.self, forKey: .zipcode)
        geo = try values.decodeIfPresent(APIGeo.self, forKey: .geo)
    }
}
