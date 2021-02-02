//
//  MainViewController.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import UIKit

protocol MainProtocol: AnyObject {
    func reloadTableWith(posts: [PostCellInfo], isPrevEnabled: Bool, isNextEnabled: Bool)
}

class MainViewController: UIViewController, MainProtocol {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableWidth: NSLayoutConstraint!
    @IBOutlet weak var rightPanel: UIView!
    @IBOutlet weak var rightPanelTitle: UILabel!
    @IBOutlet weak var rightPanelPicture: UIImageView!
    @IBOutlet weak var rightPanelContent: UILabel!
    @IBOutlet weak var rightPanelWidth: NSLayoutConstraint!
    
    private var posts: [PostCellInfo] = []
    private var isPrevEnabled: Bool = false
    private var isNextEnabled: Bool = false
    
    private let presenter: MainPresenter = MainPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        table.register(UINib(nibName: "PaginationCell", bundle: nil), forCellReuseIdentifier: "PaginationCell")
        table.dataSource = self
        table.delegate = self
        table.separatorInset = .zero
        
        presenter.delegate = self
        presenter.getTopPosts()
        
        responsiveHelper(UIScreen.main.bounds.size)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let vc = segue.destination as? PostDetailViewController,
              let selectedPostIndex = table.indexPathForSelectedRow?.item else { return }
        
        vc.post = posts[selectedPostIndex]
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        responsiveHelper(size)
    }
    
    func reloadTableWith(posts: [PostCellInfo], isPrevEnabled: Bool, isNextEnabled: Bool) {
        self.posts = posts
        self.isPrevEnabled = isPrevEnabled
        self.isNextEnabled = isNextEnabled
        table.reloadData()
    }

    private func responsiveHelper(_ size: CGSize) {
        if UIDevice.current.orientation.isLandscape {
            tableWidth.constant = -(size.width * 0.6)
            rightPanelWidth.constant = size.width * 0.6
            rightPanel.isHidden = false
        } else {
            tableWidth.constant = 0
            rightPanelWidth.constant = 0
            rightPanel.isHidden = true
        }
    }
}


extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isPrevEnabled || isNextEnabled) ? (posts.count + 1) : (posts.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item < posts.count {
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
                else { return UITableViewCell() }
            
            let post = posts[indexPath.item]
            
            myCell.updateWith(postInfo: post)
            
            return myCell
        } else {
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: "PaginationCell", for: indexPath) as? PaginationCell
                else { return UITableViewCell() }
            
            var prevCallback: (() -> Void)?
            var nextCallback: (() -> Void)?
            
            if isPrevEnabled {
                prevCallback = { [weak self] () in self?.presenter.getPrevPage() }
            }
            
            if isNextEnabled {
                nextCallback = { [weak self] () in self?.presenter.getNextPage() }
            }
            myCell.update(prevCallback: prevCallback, nextCallback: nextCallback)
            
            return myCell
            
        }
        
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        
        presenter.readPostWith(id: post.id)
        
        if !rightPanel.isHidden {
            rightPanelTitle.text = post.author
            rightPanelContent.text = post.title
            if let url = URL(string: post.thumbnail ?? "") {
                rightPanelPicture.load(url: url)
            }
        } else {
            self.performSegue(withIdentifier: "PostDetail", sender: self)
        }
        
    }
}
