//
//  PostCellTableViewCell.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 09/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import UIKit

final class CommentCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet private var commentNameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var bodyLabel: UILabel!
    
    // MARK: Public methods
    
    func configure(with comment: Comment) {
        
        commentNameLabel.text = "\(comment.name ?? "")"
        emailLabel.text = comment.email
        bodyLabel.text = comment.body
    }
}
