//
//  PostDetailViewController.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import UIKit

final class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    var post: PostCellInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = post?.author
        contentLabel.text = post?.title
        if let pictureURL = URL(string: post?.thumbnail ?? "") {
            picture.load(url: pictureURL)
        }
    }
}
