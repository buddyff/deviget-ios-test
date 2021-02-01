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
    @IBOutlet weak var arrowImage: UIImageView!
    
    func updateWith(postInfo: PostCellInfo) {
        unreadStatus.isHidden = postInfo.read
        authorLabel.text = postInfo.author
        titleLabel.text = postInfo.title
        commentsLabel.text = postInfo.comments
        timeLabel.text = postInfo.time
        arrowImage.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        arrowImage.tintColor = .white
        
        if let url = URL(string: postInfo.thumbnail ?? "") {
            self.picture.load(url: url)
        }
    }
    
    func markAsRead() {
        unreadStatus.isHidden = true
    }
}

struct PostCellInfo {
    var id: String
    var read: Bool
    var title: String
    var thumbnail: String?
    var author: String
    var comments: String
    var time: String
}
