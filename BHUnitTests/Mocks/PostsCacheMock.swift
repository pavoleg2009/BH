//
//  PostsCacheMock.swift
//  BHUnitTests
//
//  Created by Oleg Pavlichenkov on 12/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
@testable import BH

final class PostsCacheMock: PostsCache {
    
    // MARK: Public data structures
    
    enum InitialState {
        case empty
        case prepopulated
    }
    
    // MARK: Public properties
    
    private var realm: Realm {
        return RealmProvider.posts.inMemory(identifier: inMemoryIdentifier).realm
    }
    
    var inMemoryIdentifier: String = UUID().uuidString
    var initialState: InitialState = .empty
    
    
    // MARK: Public methods
    
    func saveItems<T: DatabaseConvertible>(items: [T]) {
        try? realm.write {
            realm.add(items.map { $0.databaseModel()} , update: .modified)
        }
    }
    
    func loadAllPosts() -> Observable<[Post]> {
        
        prepopulateIfNeede()
        
        let postsResults = realm.objects(DBPost.self)
            .sorted(byKeyPath: #keyPath(DBPost.id), ascending: true)
        
        return Observable
            .collection(from: postsResults, synchronousStart: false)
            .map({ dbPosts -> [Post] in
                return dbPosts.map { $0.domainModel() }
            })
    }
    
    func loadComments(for postId: Int) -> Observable<[Comment]> {
        
        prepopulateIfNeede()
        
        let commentsResult = realm
            .objects(DBComment.self)
            .filter("postId == %d", postId)
            .sorted(byKeyPath: #keyPath(DBComment.id), ascending: true)
        
        return Observable
            .collection(from: commentsResult, synchronousStart: false)
            .map({ dbComments -> [Comment] in
                return dbComments.map { $0.domainModel() }
            })
        
    }
    
    // MARK: Private methods
    
    private func prepopulateIfNeede() {
        
        switch initialState {
        case .empty:
            break
        case .prepopulated:
            preporulate()
        }
    }
    
    private func preporulate() {
        
        try! realm.write {
            
            TestsHelper.posts
                .map { $0.databaseModel() }
                .forEach {
                    realm.add($0, update: .modified)
            }
            
            TestsHelper.comments
                .map { $0.databaseModel() }
                .forEach {
                    realm.add($0, update: .modified)
            }
        }
    }
}
