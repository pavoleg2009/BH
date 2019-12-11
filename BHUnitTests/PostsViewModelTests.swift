//
//  PostsViewModelTests.swift
//  BHUnitTests
//
//  Created by Oleg Pavlichenkov on 06/01/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RealmSwift
@testable import BH

class PostsViewModelTests: XCTestCase {
    
    let postsCacheMock = PostsCacheMock()
    let postsServiceMock = PostsServiceMock()
    
    let scheduler = TestScheduler(initialClock: 0)
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    /*
     to test viewModel.init with different external conditions:
     1) 1st app launch - emtpy cache, network is OK
     2) default app launch: cache is not empty, network is OK
     3) cache is not empty, no internet connection
     
     */
    struct PostsVMTestConditions {
        let testName: String
        let cacheInitialState: PostsCacheMock.InitialState
        let apiExpectedResult: PostsServiceMock.GetPostsExpectedResult
        // to get certain amount of values in observable
        let expectedFulfillmentCount: Int
    }
    
    struct PostsVMTestOutputs {
        let receivedPostsCount: [Int]
        let receivedErrors: [String]?
    }
    
    private func executeTest(with params: PostsVMTestConditions) -> PostsVMTestOutputs {
        
        postsCacheMock.inMemoryIdentifier = params.testName
        postsCacheMock.initialState = params.cacheInitialState
        postsServiceMock.getPostsExpectedResult = params.apiExpectedResult
        
        let postsObserver = scheduler.createObserver([Post].self)
        let errorsObserver = scheduler.createObserver(String.self)
        
        let promise = expectation(description: "")
        promise.expectedFulfillmentCount = params.expectedFulfillmentCount
        
        // Act
        let viewModel = PostsViewModel(
            postsCache: postsCacheMock,
            postsService: postsServiceMock,
            router: AppCoordinator().anyRouter)
        
        viewModel.posts.asObservable()
            .do(onNext: { _ in promise.fulfill() })
            .bind(to: postsObserver)
            .disposed(by: bag)
        
        viewModel.errorMessage.asObservable()
            .do(onNext: { _ in promise.fulfill() })
            .bind(to: errorsObserver)
            .disposed(by: bag)
        
        scheduler.scheduleAt(0) {
            viewModel.loadInitialData.onNext(())
        }
        scheduler.start()
        
        // Assert
        wait(for: [promise], timeout: 2)
        
        let receivedPostsCount = postsObserver.events
            .compactMap { $0.value.element?.count }
        let receivedErrors = errorsObserver.events
            .compactMap { $0.value.element }
        
        return PostsVMTestOutputs(
            receivedPostsCount: receivedPostsCount,
            receivedErrors: receivedErrors
        )
    }
    
    func test_onLaunchWithEmptyCache_shouldFetchSaveAndShowPosts() {
        
        let expextedPostsCounts = [
            0, // initial value
            0, // 0 posts read from empty cache
            3] // 3 posts fetched fom api
        
        let expextedErrors = [String]() // no errors
        
        let expectedFulfillmentCount = expextedPostsCounts.count
            + expextedErrors.count
        
        let conditions = PostsVMTestConditions(
            
            testName: #function,
            cacheInitialState: .empty,
            apiExpectedResult: .success,
            expectedFulfillmentCount: expectedFulfillmentCount)
        
        let testOutputs = executeTest(with: conditions)
        
        XCTAssertEqual(testOutputs.receivedPostsCount,
                       expextedPostsCounts)
        XCTAssertEqual(testOutputs.receivedErrors, expextedErrors)
    }
    
    func test_onLaunchWithFilledCache_shouldFetchSaveAndShowPosts() {
        
        let  expextedPostsCounts = [
            0, // initial value
            3, // 3 posts read from cache
            3] // 3 posts fetched fom api
        
        let expextedErrors = [String]() // no errors
        
        let expectedFulfillmentCount = expextedPostsCounts.count
            + expextedErrors.count
        
        let conditions = PostsVMTestConditions(
            testName: #function,
            cacheInitialState: .prepopulated,
            apiExpectedResult: .success,
            expectedFulfillmentCount: expectedFulfillmentCount)
        
        let testOutputs = executeTest(with: conditions)
        
        XCTAssertEqual(testOutputs.receivedPostsCount,
                       expextedPostsCounts)
        XCTAssertEqual(testOutputs.receivedErrors, expextedErrors)
    }
    
    func test_onLaunchWithNoConnection_shoulGetError() {
        
        let expextedPostsCounts = [
            0, // initial value
            3] // 3 posts read from cache
            // 3 posts fetched fom api
        
        let expextedErrors = ["Unknown Errror"]
        
        let expectedFulfillmentCount = expextedPostsCounts.count
                                     + expextedErrors.count
        
        let conditions = PostsVMTestConditions(
            testName: #function,
            cacheInitialState: .prepopulated,
            apiExpectedResult: .error(ApiError.unknown),
            expectedFulfillmentCount: expectedFulfillmentCount)
        
        let testOutputs = executeTest(with: conditions)
        
        XCTAssertEqual(testOutputs.receivedPostsCount,
                       expextedPostsCounts)
        XCTAssertEqual(testOutputs.receivedErrors, expextedErrors)
    }
    
    func test_onRefresh_shouldFetchPosts() {
        
        // Arrange
        
        postsCacheMock.inMemoryIdentifier = #function
        postsCacheMock.initialState = .empty
        postsServiceMock.getPostsExpectedResult = .success
        
        let viewModel = PostsViewModel(
                postsCache: postsCacheMock,
                postsService: postsServiceMock,
                router: AppCoordinator().anyRouter)
        
        let postsObserver = scheduler.createObserver([Post].self)
        let promise = expectation(description: "")
        /* We should observe 4 values of type [Post]
        
         1) initial (empty),
         2) empty cache
         3) fetch from API mock - 3 items
         4) on refresh: re-fetch from api mock - 3 items
         */
        promise.expectedFulfillmentCount = 4

        viewModel.posts
            .do(onNext: { _ in promise.fulfill() })
            .bind(to: postsObserver)
            .disposed(by: bag)
        
        scheduler.scheduleAt(0) {
            viewModel.loadInitialData.onNext(Void())
            
            // Act
            viewModel.refresh.onNext(Void())
        }
        
        scheduler.start()
        
        // Assert
        wait(for: [promise], timeout: 3)
        
        let receivedPostsCount = postsObserver.events
            .compactMap { $0.value.element?.count }
        
        XCTAssertEqual(receivedPostsCount, [0, 0, 3, 3])
    }
}
