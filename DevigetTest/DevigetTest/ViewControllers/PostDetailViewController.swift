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
    
    var author: String?
    var pictureURL: URL?
    var content: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = author
        contentLabel.text = content
        if let pictureURL = pictureURL {
            picture.load(url: pictureURL)
        }
    }
}
