//
//  PostDetailsViewModelTests.swift
//  BHUnitTests
//
//  Created by Oleg Pavlichenkov on 16/02/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import Foundation

import XCTest
import RxSwift
import RxTest
import RealmSwift
@testable import BH

class PostDetailsViewModelTests: XCTestCase {
    
    let postsCacheMock = PostsCacheMock()
    let postsServiceMock = PostsServiceMock()
    
    let scheduler = TestScheduler(initialClock: 0)
    let bag = DisposeBag()
    
    struct PostDetailsVMTestConditions {
        let testName: String
        let cacheInitialState: PostsCacheMock.InitialState
        let apiExpectedResult: PostsServiceMock.GetPostsExpectedResult
        // to get certain amount of values in observable
        let expectedFulfillmentCount: Int
    }
    
    struct PostDetailsVMTestOutputs {
        let receivedCommentsCountStrings: [String]
        let receivedErrors: [String]?
    }
    
    private func executeTest(with params: PostDetailsVMTestConditions) -> PostDetailsVMTestOutputs {
        
        postsCacheMock.inMemoryIdentifier = #function
        postsCacheMock.initialState = params.cacheInitialState
        postsServiceMock.getPostsExpectedResult = params.apiExpectedResult
        
        let commentsCountObserver = scheduler.createObserver(String.self)
        let errorsObserver = scheduler.createObserver(String.self)
        
        let promise = expectation(description: "")
        promise.expectedFulfillmentCount = params.expectedFulfillmentCount
        
        // Act
        let viewModel = PostDetailsViewModel(
            post: TestsHelper.posts[0],
            postsCache: postsCacheMock,
            postsService: postsServiceMock)
        
        viewModel.commentsCount.asObservable()
            .do(onNext: { _ in promise.fulfill() })
            .bind(to: commentsCountObserver)
            .disposed(by: bag)
        
        viewModel.errorMessage.asObservable()
            .do(onNext: { _ in promise.fulfill() })
            .bind(to: errorsObserver)
            .disposed(by: bag)
        
        scheduler.scheduleAt(0) {
            viewModel.loadInitialData.onNext(())
        }
        scheduler.start()
        
        wait(for: [promise], timeout: 3)
        
        let receivedCommentsCount = commentsCountObserver.events
            .compactMap { $0.value.event.element }
        
        let receivedErrors = errorsObserver.events
            .compactMap { $0.value.element }
        
        return PostDetailsVMTestOutputs(
            receivedCommentsCountStrings: receivedCommentsCount,
            receivedErrors: receivedErrors
        )
    }
    
    func test_onInit_shouldFetchCommentsCount() {
        
        // Arrange
        
        let expectedCommentsConuntStrings = [
            "Comments: 0", // initial value
            "Comments: 3"]
        
        let expextedErrors = [String]() // no errors
        let expectedFulfillmentCount = expectedCommentsConuntStrings.count
            + expextedErrors.count
        
        let conditions = PostDetailsVMTestConditions(
            
            testName: #function,
            cacheInitialState: .prepopulated,
            apiExpectedResult: .success,
            expectedFulfillmentCount: expectedFulfillmentCount)
        
        let testOutputs = executeTest(with: conditions)
        
        XCTAssertEqual(expectedCommentsConuntStrings, testOutputs.receivedCommentsCountStrings)
        XCTAssertEqual(testOutputs.receivedErrors, expextedErrors)
    }
}
