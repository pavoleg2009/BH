//
//  APIGeo.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 10/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

struct APIGeo {
    
    // MARK: Public properties
    
	let lat: String?
	let lng: String?
}

extension APIGeo: Codable {
    
    // MARK: Public data structures
    
	enum CodingKeys: String, CodingKey {
		case lat, lng
	}

    
    // MARK: Lifecycle
    
	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		lat = try values.decodeIfPresent(String.self, forKey: .lat)
		lng = try values.decodeIfPresent(String.self, forKey: .lng)
	}

}
