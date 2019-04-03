//
//  PostsServiceMock.swift
//  BHUnitTests
//
//  Created by Oleg Pavlichenkov on 08/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import RxSwift
@testable import BH

final class PostsServiceMock: PostsService {
    
    // MARK: Public data structures
    
    enum GetPostsExpectedResult {
        case success
        case error(Error)
    }
    
    
    // MARK: Public properties
    
    var getPostsExpectedResult: GetPostsExpectedResult = .success
    
    
    // MARK: Public methods
    
    func getPosts() -> Single<[Post]> {
        return Single.create(subscribe: { single in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                switch self.getPostsExpectedResult {
                case .success:
                    single(.success(TestsHelper.posts))
                case .error(let error):
                    single(.error(error))
                }
            })
            
            return Disposables.create()
        })
    }
    
    func getComments(for postId: Int) -> Single<[Comment]> {
        return Single.create(subscribe: { single in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                switch self.getPostsExpectedResult {
                case .success:
                    single(.success(TestsHelper.comments))
                case .error(let error):
                    single(.error(error))
                }
            })
            
            return Disposables.create()
        })
    }
    
    func getCommentsCount(for postId: Int) -> Single<Int> {
        return Single.create(subscribe: { single in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                switch self.getPostsExpectedResult {
                case .success:
                    single(.success(123))
                case .error(let error):
                    single(.error(error))
                }
            })
            
            return Disposables.create()
        })
    }
}
