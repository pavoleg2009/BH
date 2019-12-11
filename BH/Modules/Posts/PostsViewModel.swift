//
//  PostsViewModel.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 05/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRealm
import XCoordinator

protocol PostsViewModelProtocol: AnyObject {
    
    var postSelectedId: PublishSubject<Int> { get }
    var loadInitialData: PublishSubject<()> { get }
    var refresh: PublishSubject<()> { get }
    var selectedPost: PublishSubject<Post> { get }

    var posts: BehaviorRelay<[Post]> { get }
    var isLoading: Driver<Bool> { get }
    var errorMessage: Driver<String> { get }
}

final class PostsViewModel: PostsViewModelProtocol {

    // MARK: Public properties
    
    let postSelectedId: PublishSubject<Int> = .init()
    let refresh: PublishSubject<()> = .init()
    let loadInitialData: PublishSubject<()> = .init()
    let selectedPost: PublishSubject<Post> = .init()
    let posts: BehaviorRelay<[Post]> = .init(value: [])
    let isLoading: Driver<Bool>
    let errorMessage: Driver<String>
    
    // MARK: Private properties
    
    private let router: AnyRouter<AppRoute>
    private let postsCache: PostsCache
    private let postsService: PostsService
    private let errorMessagePublisher: PublishSubject<String> = .init()
    private let bag = DisposeBag()
    
    // MARK: Lifecycle
    
    init(postsCache: PostsCache = PostsCacheDefault(),
         postsService: PostsService = PostsServiceDefault(),
         router: AnyRouter<AppRoute>
        ) {
        
        self.postsCache = postsCache
        self.postsService = postsService
        self.router = router
        
        isLoading = Observable.from([
                loadInitialData.asObservable().map { _ in true },
                refresh.asObservable().map { _ in true },
                posts.asObservable()
                    .skip(1) // initial empty array
                    .map { _ in false },
                errorMessagePublisher.asObservable().map { _ in false }
        ])
            .merge()
            .startWith(true)
            .asDriver(onErrorJustReturn: false)
        
        errorMessage = errorMessagePublisher
            .asDriver(onErrorJustReturn: "")
        
        refresh.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.fetchPostsAndSaveToCache()
            })
            .disposed(by: bag)
        
        loadInitialData.asObserver()
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.loadPostsFromCache()
                strongSelf.fetchPostsAndSaveToCache()
            })
            .disposed(by: bag)
        
        selectedPost.asObserver()
            .subscribe(onNext: { [weak self] post in
                guard let strongSelf = self else { return }
                strongSelf.router.trigger(.post(post: post))
            })
            .disposed(by: bag)
    }
    
    // MARK: Private methods
    
    private func loadPostsFromCache() {
        
        postsCache.loadAllPosts()
            .bind(to: posts)
            .disposed(by: bag)
    }
    
    private func fetchPostsAndSaveToCache() {
        
        let postsResult = postsService
            .getPosts()
        
        let errorHandler: (Error) -> Observable<[Post]> = { [weak self] error in
            
            guard let strongSelf = self else { return .never() }
            
            if let error = error as? ApiError {
                strongSelf.errorMessagePublisher.onNext(error.errorMessage())
            } else {
                strongSelf.errorMessagePublisher.onNext((error as NSError).localizedDescription)
            }
            return .never()
        }
        
        postsResult.asObservable()
            .catchError(errorHandler)
            .subscribe(onNext: { [weak self] posts in
                self?.postsCache.saveItems(items: posts)
            })
            .disposed(by: bag)
    }
}
