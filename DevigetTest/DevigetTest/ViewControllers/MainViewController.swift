//
//  MainViewController.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import UIKit

protocol MainProtocol: AnyObject {
    func reloadTableWith(posts: [PostCellInfo])
}

class MainViewController: UIViewController, MainProtocol {

    @IBOutlet weak var table: UITableView!
    
    private var posts: [PostCellInfo] = []
    
    private let presenter: MainPresenter = MainPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        table.dataSource = self
        table.delegate = self
        table.separatorInset = .zero
        
        presenter.delegate = self
        presenter.getTopPosts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let vc = segue.destination as? PostDetailViewController,
              let selectedPostIndex = table.indexPathForSelectedRow?.item else { return }
        
        let selectedPost = posts[selectedPostIndex]
        
        vc.author = selectedPost.author
        vc.content = selectedPost.title
        
        if let url = URL(string: selectedPost.thumbnail ?? "") {
            vc.pictureURL = url
        }
    }
    
    func reloadTableWith(posts: [PostCellInfo]) {
        self.posts = posts
        table.reloadData()
    }

}


extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
            else { return UITableViewCell() }
        
        let post = posts[indexPath.item]
        
        myCell.updateWith(postInfo: post)
        
        return myCell
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PostDetail", sender: self)
    }
}

