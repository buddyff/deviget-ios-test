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
    
    func getTopPosts() {
        repository.getTopPosts() { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    let posts: [PostCellInfo] = response.data.children.map { (post) -> PostCellInfo in
                        let createdDate = post.data.created.toDate()
                        let hoursDiff = Date().hoursDiff(date: createdDate)
                        
                        return PostCellInfo(
                            read: false,
                            title: post.data.title,
                            thumbnail: post.data.thumbnail,
                            author: post.data.author,
                            comments: "\(post.data.comments) comments",
                            time: "\(hoursDiff) \(hoursDiff > 1 ? "hours" : "hour") ago"
                        )
                    }
                    self?.delegate?.reloadTableWith(posts: posts)
                }                
            case .failure(let error):
                print(error)
            }
        }
    }
}
