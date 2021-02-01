//
//  PostCell.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import Foundation
import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var unreadStatus: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!
    
    func update(read: Bool, author: String, picture: String?, title: String, comments: String) {
        unreadStatus.isHidden = read
        authorLabel.text = author
        titleLabel.text = title
        commentsLabel.text = comments
    }
    
}
