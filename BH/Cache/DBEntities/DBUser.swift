//
//  DBUser.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 05/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import RealmSwift

final class DBUser: Object {
    
    // MARK: Public properties
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var username: String? = nil
    @objc dynamic var email: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }   
}

extension DBUser: DomainConvertible {
    
    typealias DomainType = User
    
    
    // MARK: Public methods
    
    func domainModel() -> User {
        
        return User(
            id: id,
            name: name,
            username: username,
            email: email)
    }
}

