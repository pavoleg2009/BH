//
//  DBPost.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 05/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import RealmSwift

final class DBPost: Object {
    
    // MARK: Public properties
    
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var body: String?
    @objc dynamic var user: DBUser?
    
    
    // MARK: Public methods
    
    override static func primaryKey() -> String? {
        return "id"
    }  
}

extension DBPost: DomainConvertible {
    
    typealias DomainType = Post
    
    
    // MARK: Public methods
    
    func domainModel() -> Post {
        return Post(id: id,
                    title: title,
                    body: body,
                    user: user?.domainModel() ?? User.empty())
    }
}
