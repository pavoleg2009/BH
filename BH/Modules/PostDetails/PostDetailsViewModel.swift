//
//  PostDetailsViewModel.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 13/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRealm

protocol PostDetailsViewModelType {
    
    var post: Post { get }
    var loadInitialData: PublishSubject<()> { get }
    
    var comments: BehaviorRelay<[Comment]> { get }
    var commentsCount: Driver<String> { get }
    var isLoading: Driver<Bool> { get }
    var errorMessage: Driver<String> { get }
}

final class PostDetailsViewModel: PostDetailsViewModelType {
    
    // MARK: Public properties
    
    let post: Post
    let loadInitialData: PublishSubject<()> = .init()
    
    let comments: BehaviorRelay<[Comment]> = .init(value: [])
    let commentsCount: Driver<String>
    let isLoading: Driver<Bool>
    let errorMessage: Driver<String>
    
    
    // MARK: Private properties
    
    private let postsCache: PostsCache
    private let postsService: PostsService
    
    private let bag = DisposeBag()
    private let commentsCountBRelay: BehaviorRelay<String> = .init(value: "Loading...")
    private let errorMessagePublisher: PublishSubject<String> = .init()
    
    
    // MARK: Lifecycle
    
    init(post: Post,
         postsCache: PostsCache = PostsCacheDefault(),
         postsService: PostsService = PostsServiceDefault()) {
        
        self.post = post
        self.postsCache = postsCache
        self.postsService = postsService
        
        commentsCount = commentsCountBRelay.asDriver()
        
        isLoading = Observable.from([
            comments.asObservable().map { _ in false },
            errorMessagePublisher.asObservable().map { _ in false }
            ])
            .merge()
            .startWith(true)
            .asDriver(onErrorJustReturn: false)
        
        errorMessage = errorMessagePublisher.asDriver(onErrorJustReturn: "")
        
        comments.asObservable()
            .map { "Comments: \($0.count)" }
            .bind(to: commentsCountBRelay)
            .disposed(by: bag)
        
        loadInitialData.asObserver()
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.loadCommentsFromCache()
                strongSelf.fetchCommentsAndSaveToCache(for: post.id)
            }).disposed(by: bag)
    }
    
    
    // MARK: Private methods
    
    private func loadCommentsFromCache() {
        
        postsCache.loadComments(for: post.id)
            .bind(to: comments)
            .disposed(by: bag)
    }
    
    private func fetchCommentsAndSaveToCache(for postId: Int) {
        
        let commentsResult = postsService
            .getComments(for: postId)
        
        let errorHandler: (Error) -> Observable<[Comment]> = { [weak self] (error) in
            
            guard let strongSelf = self else { return .never() }
            if let error = error as? ApiError {
                strongSelf.errorMessagePublisher.onNext(error.errorMessage())
            }
            else  {
                strongSelf.errorMessagePublisher.onNext((error as NSError).localizedDescription)
            }
            return .never()
        }
        
        commentsResult.asObservable()
            .catchError(errorHandler)
            .subscribe(onNext: { [weak self] comments in
                self?.postsCache.saveItems(items: comments)
            }).disposed(by:bag)
    }
}
