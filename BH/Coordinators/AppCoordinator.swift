//
//  AppCoordinator.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 30/03/2019.
//  Copyright © 2019 Oleg Pavlichenkov. All rights reserved.
//

import UIKit
import XCoordinator

enum AppRoute: Route {
    case posts
    case post(post: Post)
}

final class AppCoordinator: NavigationCoordinator<AppRoute> {
    
    init() {
        super.init(initialRoute: .posts)
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        
        switch route {
        case .posts:

            let postsViewController: PostsViewController = .fromStoryboard()
            let postsViewModel = PostsViewModel(router: anyRouter)
            postsViewController.viewModel = postsViewModel
            
            return .push(postsViewController)
            
        case .post(let post):

            let postDetailsViewController: PostDetailsViewController = .fromStoryboard()
            let postDeatilsViewModel = PostDetailsViewModel(post: post)
            postDetailsViewController.viewModel = postDeatilsViewModel
            
            return .push(postDetailsViewController)
        }
    }
}
