//
//  PostsCache.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 06/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import RealmSwift
import RxSwift

protocol PostsCache {
    
    func saveItems<T: DatabaseConvertible>(items: [T])
    func loadAllPosts() -> Observable<[Post]>
    func loadComments(for postId: Int) -> Observable<[Comment]>
}

final class PostsCacheDefault: PostsCache {
    
    // MARK: Private properties
    
    private var realm: Realm {
        return realmProvider.posts.realm 
    }
    
    // MARK: Lifecycle
    
    private var realmProvider: RealmProviderProtocol.Type
    
    init(realmProvider: RealmProviderProtocol.Type = RealmProvider.self) {
        self.realmProvider = realmProvider
    }
    
    
    // MARK: Public methods
    
    func saveItems<T: DatabaseConvertible>(items: [T]) {
        // Should be handled better in production
        try? realm.write {
            realm.add(items.map { $0.databaseModel()} , update: true)
        }
    }
    
    func loadAllPosts() -> Observable<[Post]> {
        let postsResults = realm.objects(DBPost.self)
            .sorted(byKeyPath: #keyPath(DBPost.id), ascending: true)
        
        return Observable
            .collection(from: postsResults, synchronousStart: false)
            .map({ dbPosts -> [Post] in
                return dbPosts.map { $0.domainModel() }
            })
    }
    
    func loadComments(for postId: Int) -> Observable<[Comment]> {
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
}
