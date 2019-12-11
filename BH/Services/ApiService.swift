//
//  ApiService.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 01/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ApiService {
    
    func getAPIPosts() -> Single<[APIPost]>
    func getAPIUsers() -> Single<[APIUser]>
    func getAPIComments() -> Single<[APIComment]>
}

protocol Requestable: Codable {
    
    static var endpoint: ApiEndpoint { get }
}

final class ApiServiceDefault: ApiService {
    
    // MARK: Private properties
    
    private let urlSession: URLSession
    
    // MARK: Lifecycle
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    // MARK: Public methods
    
    func getAPIPosts() -> Single<[APIPost]> {
        return getItems()
    }
    
    func getAPIUsers() -> Single<[APIUser]> {
        return getItems()
    }
    
    func getAPIComments() -> Single<[APIComment]> {
        return getItems()
    }
    
    // MARK: Private methods
    
    func getItems<T: Requestable>() -> Single<[T]> {
        
        let request = Observable.of(T.endpoint.url())
            .map { URLRequest(url: $0) }
        
        let response = request
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                URLSession.shared.rx.response(request: request)
            }
        
        let successfulResponse = response
            .filter { response, _ -> Bool in
                200..<400 ~= response.statusCode
            }
            .flatMap { _, data -> Observable<[T]> in
                let decoder = JSONDecoder()
                let items = (try? decoder.decode([T].self, from: data)) ?? []
                return Observable.of(items)
            }
            .asSingle()
        
        return successfulResponse
    }
}
