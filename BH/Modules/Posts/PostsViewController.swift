//
//  ViewController.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 30/11/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import UIKit
import RxSwift

final class PostsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: Public properties
    
    var viewModel: PostsViewModelProtocol! {
        didSet {
            configure(using: viewModel)
        }
    }
    
    
    // MARK: Private properties
    
    private var refreshControl: UIRefreshControl = {
        
        let rc = UIRefreshControl()
        rc.tintColor = .red
        
        return rc
    }()
    
    private let bag = DisposeBag()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.refreshControl = refreshControl
        title = "Posts"
    }
    
    
    // MARK: Private methods
    
    private func configure(using viewModel: PostsViewModelProtocol!) {
        
        loadViewIfNeeded()
        
        configureRefreshControl()
        configureTableViewToShowPosts()
        configureErrorHandling()
        
        viewModel.loadInitialData.onNext(())
    }
    
    private func configureRefreshControl() {
        
        let refreshControlDidStartRefreshing = refreshControl.rx
            .controlEvent(.valueChanged)
            .map { [weak self] _ in
                self?.refreshControl.isRefreshing == true
            }
            .filter { $0 }
            .map { _ in Void() }
        
        refreshControlDidStartRefreshing
            .bind(to: viewModel.refresh)
            .disposed(by: bag)
        
        viewModel.isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: bag)
    }
    
    private func configureTableViewToShowPosts() {
        
        let cellIdentifier = "PostCell"
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        viewModel.posts.asObservable()
            .bind(to: tableView.rx.items) { tableView, index, post in
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PostCell else { fatalError("Unknown cell type") }
                
                cell.configure(using: post)
                
                return cell
            }
            .disposed(by: bag)
        
        tableView.rx
            .modelSelected(Post.self)
            .subscribe(viewModel.selectedPost)
            .disposed(by: bag)
    }
    
    private func configureErrorHandling() {

        viewModel.errorMessage
            .drive(rx.alertWithErrorString)
            .disposed(by: bag)
    }
}


