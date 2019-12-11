//
//  RealmProvider+Ext.swift
//  BHUnitTests
//
//  Created by Oleg Pavlichenkov on 12/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

import RealmSwift

@testable import BH

extension RealmProvider {
    
    func inMemory(identifier: String) -> RealmProvider {
        
        var conf = self.configuration
        conf.inMemoryIdentifier = identifier
        conf.readOnly = false
        return RealmProvider(config: conf)
    }
}

extension Realm {
    
    func addForTesting(objects: [Object]) {
        
        // swiftlint:disable:next force_try
        try! write {
            add(objects)
        }
    }
}
