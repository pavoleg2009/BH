//
//  RealmProvider.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 12/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmProviderProtocol {
    
    static var posts: RealmProvider { get }
    
    var realm: Realm { get }
}

struct RealmProvider: RealmProviderProtocol {
    
    // MARK: Public properties
    
    public static var posts: RealmProvider = {
        return RealmProvider(config: postsConfiguration)
    }()
    
    var realm: Realm {
        // Should be handled better in production
        guard let realm = try? Realm(configuration: configuration) else {
            fatalError("Could not open Realm file")
        }
        return realm
    }
    
    
    // MARK: Private properties
    
    private static let realmFileName = "posts.realm"

    private static let realmUrl = FileManager.documentDirectory
        .appendingPathComponent(realmFileName)
    
    private static let postsConfiguration = Realm.Configuration(
        fileURL: realmUrl,
        schemaVersion: 1,
        deleteRealmIfMigrationNeeded: true)
    
    // internal (not private) for testing
    let configuration: Realm.Configuration
    
    // MARK: Lifecycle
    
    // internal (not private) for testing
    init(config: Realm.Configuration) {
        self.configuration = config
    }
}
