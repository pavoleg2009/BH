//
//  PostDetailScreen.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 23/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import UIKit
import RxSwift

final class PostDetailsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var authorName: UILabel!
    @IBOutlet private weak var authorUsername: UILabel!
    @IBOutlet private weak var authorEmail: UILabel!
    @IBOutlet private weak var postBody: UILabel!
    @IBOutlet private weak var commentsCount: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Puplic properties
    
    var viewModel: PostDetailsViewModelType! {
        didSet {
            configure(with: viewModel) // Название (2)
        }
    }
    
    // MARK: Private properties
    
    private let bag = DisposeBag()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() { // Удалить раз не нужен
        super.viewDidLoad()
    }
    
    // MARK: Private methods
    
    private func configure(with viewModel: PostDetailsViewModelType!) {
        
        loadViewIfNeeded()
        
        configureTableViewToShowComments()
        configureErrorHandling()
        configureStaticLabels(with: viewModel)
        
        viewModel.commentsCount
            .drive(commentsCount.rx.text)
            .disposed(by: bag)
        
        viewModel.loadInitialData.onNext(())
    }
    
    private func configureTableViewToShowComments() {
        
        let cellIdentifier = "CommentCell"
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        viewModel.comments.asObservable()
            .bind(to: tableView.rx.items) { tableView, index, comment in
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CommentCell else { fatalError("Unknown cell type") }
                
                cell.configure(with: comment)
                
                return cell
            }
            .disposed(by: bag)
    }
    
    private func configureErrorHandling() {
        
        viewModel.errorMessage
            .drive(rx.alertWithErrorString)
            .disposed(by: bag)
    }
    
    private func configureStaticLabels(with viewModel: PostDetailsViewModelType) {
        
        authorName.text = viewModel.post.user.name
        authorUsername.text = viewModel.post.user.username
        authorEmail.text = viewModel.post.user.email
        postBody.text = viewModel.post.body
    }
}
