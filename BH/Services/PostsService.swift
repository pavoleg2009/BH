//
//  PostsService.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 08/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import RxSwift

protocol PostsService {
    
    func getPosts() -> Single<[Post]>
    func getComments(for postId: Int) -> Single<[Comment]>
}

final class PostsServiceDefault: PostsService {
    
    // MARK: Provate methods
    
    private let apiService: ApiService
    
    
    // MARK: Lifecycle
    
    init(apiService: ApiService = ApiServiceDefault()) {
        self.apiService = apiService
    }
    
    
    // MARK: Public methods
    
    func getPosts() -> Single<[Post]> {
        
        let apiUsers = apiService.getAPIUsers()
        let apiPosts = apiService.getAPIPosts()
        
        let posts = Observable
            .combineLatest(apiPosts.asObservable(),
                           apiUsers.asObservable(),
                           resultSelector: createPosts)
        
        return posts.asSingle()
    }
    
    func getComments(for postId: Int) -> Single<[Comment]> {
        let apiCommetns = apiService.getAPIComments()
        
        return apiCommetns.map { apiCommentsArray in
            apiCommentsArray
                .filter { $0.postId == postId }
                .compactMap { Comment(with: $0) }
        }
    }
    
    
    // MARK: Private methods
    
    private func createPosts(with apiPostsArr: [APIPost], and apiUsersArr: [APIUser]) -> [Post] {
    
        let users = apiUsersArr.compactMap { User(with: $0) }
        
        return apiPostsArr.compactMap({ apiPost -> Post? in

            guard let user = users.first(where: { (user) -> Bool in
                apiPost.userId == user.id
            }) else {
                return nil
            }
            return Post(with: apiPost, and: user)
        })
    }
}
