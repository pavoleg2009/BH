//
//  PostCellTableViewCell.swift
//  BH
//
//  Created by Oleg Pavlichenkov on 09/12/2018.
//  Copyright © 2018 Oleg Pavlichenkov. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var postTitleLabel: UILabel!
    
    
    // MARK: Public methods
    
    func configure(using post: Post) {
        
        authorLabel.text = post.user.name
        postTitleLabel.text =  "Id: \(post.id) - \(post.title)"
    }
}
