//
//  APIComment.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 10/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

struct APICompany {
    
    // MARK: Public properties
    
	let name: String?
	let catchPhrase: String?
	let bs: String?
}

extension APICompany: Codable {
	
    // MARK: Public data structures
    
    enum CodingKeys: String, CodingKey {
		case name, catchPhrase, bs
	}

    
    // MARK: Lifecycle
    
	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		catchPhrase = try values.decodeIfPresent(String.self, forKey: .catchPhrase)
		bs = try values.decodeIfPresent(String.self, forKey: .bs)
	}

}
