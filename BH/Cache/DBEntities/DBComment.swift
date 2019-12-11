//
//  DBComment.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 17/02/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import RealmSwift

final class DBComment: Object {
    
    // MARK: Public properties
    
    @objc dynamic var postId: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String?
    @objc dynamic var email: String?
    @objc dynamic var body: String?
    
    // MARK: Public methods
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension DBComment: DomainConvertible {
    
    typealias DomainType = Comment
    
    // MARK: Public methods
    
    func domainModel() -> Comment {
        return Comment(
            postId: postId,
            id: id,
            name: name,
            email: email,
            body: body)
    }
}
