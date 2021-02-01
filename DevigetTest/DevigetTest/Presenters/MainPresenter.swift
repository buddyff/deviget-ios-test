//
//  MainPresenter.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import Foundation

final class MainPresenter {
    
    weak var delegate: MainProtocol?
    
    private let repository: MainRepository = MainRepository()
    private var posts: [PostCellInfo] = []
    
    func getTopPosts() {
        repository.getTopPosts() { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async { [weak self] () in
                    self?.posts = response.data.children.map { (post) -> PostCellInfo in
                        let createdDate = post.data.created.toDate()
                        let hoursDiff = Date().hoursDiff(date: createdDate)
                        let isRead = UserDefaults.standard.bool(forKey: post.data.id)
                        
                        return PostCellInfo(
                            id: post.data.id,
                            read: isRead,
                            title: post.data.title,
                            thumbnail: post.data.thumbnail,
                            author: post.data.author,
                            comments: "\(post.data.comments) comments",
                            time: "\(hoursDiff) \(hoursDiff > 1 ? "hours" : "hour") ago"
                        )
                    }
                    self?.delegate?.reloadTableWith(posts: self?.posts ?? [])
                }                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func readPostWith(id: String) {
        UserDefaults.standard.setValue(true, forKey: id)
        if let readPostIndex = posts.firstIndex(where: { $0.id == id }) {
            posts[readPostIndex].read = true            
            DispatchQueue.main.async { [weak self] () in
                self?.delegate?.reloadTableWith(posts: self?.posts ?? [])
            }
        }
        
    }
}
