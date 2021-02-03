//
//  MainPresenter.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import UIKit

final class MainPresenter {
    
    weak var delegate: MainProtocol?
    
    private let repository: MainRepositoryProtocol
    private let userDefaultsManager: UserDefaultsProtocol
    private var posts: [PostCellInfo] = []
    private var currentPage: Int = 0
    private var currentNext: String?
    private var lastPage: Int?
    
    required init(_ repository: MainRepositoryProtocol, _ userDefaultsManager: UserDefaultsProtocol) {
        self.repository = repository
        self.userDefaultsManager = userDefaultsManager
    }
    
    func getTopPosts() {
        repository.getTopPosts() { [weak self] (result) in
            switch result {
            case .success(let response):                
                self?.posts = response.data.children.map { (post) -> PostCellInfo in
                    let createdDate = post.data.created.toDate()
                    let hoursDiff = Date().hoursDiff(date: createdDate)
                    let isRead = UserDefaults.standard.bool(forKey: post.data.id)
                    return PostCellInfo(from: post, read: isRead, hoursDiff: hoursDiff)
                }
                
                self?.currentNext = response.data.after
                
                let isNextEnabled = response.data.after != nil
                let filteredPosts = self?.posts.filter { !UserDefaults.standard.bool(forKey: "d\($0.id)") }
                
                self?.delegate?.reloadTableWith(posts: filteredPosts ?? [], isPrevEnabled: false, isNextEnabled: isNextEnabled)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func readPostWith(id: String) {
        userDefaultsManager.readPostWith(id: id)
        
        if let readPostIndex = posts.firstIndex(where: { $0.id == id }) {
            posts[readPostIndex].read = true
            let postsToRender = self.getCurrentPagePosts()
            let isPrevEnabled = self.currentPage != 0
            let isNextEnabled = (self.lastPage != nil && self.currentPage != self.lastPage) || self.currentNext != nil
            self.delegate?.reloadTableWith(posts: postsToRender, isPrevEnabled: isPrevEnabled, isNextEnabled: isNextEnabled)
        }
    }
    
    func getNextPage() {
        // Check if page info was already fetched
        if (posts.count) > (Constants.postsLimitPerPage * (currentPage + 1)) {
            currentPage += 1
            let postsToRender = getCurrentPagePosts()
            delegate?.reloadTableWith(posts: postsToRender, isPrevEnabled: true, isNextEnabled: currentPage != lastPage)
        } else {
            guard let currentNext = currentNext else { return }
            
            repository.getNextTopPosts(after: currentNext) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):                    
                    let incomingPosts = response.data.children
                    var isPrevEnabled = false
                    
                    if !incomingPosts.isEmpty {
                        self.currentPage += 1
                        isPrevEnabled = true
                        
                        self.posts += response.data.children.map { (post) -> PostCellInfo in
                            let createdDate = post.data.created.toDate()
                            let hoursDiff = Date().hoursDiff(date: createdDate)
                            let isRead = UserDefaults.standard.bool(forKey: post.data.id)
                            return PostCellInfo(from: post, read: isRead, hoursDiff: hoursDiff)
                        }
                    }
                    
                    self.currentNext = response.data.after
                    
                    if (self.currentNext == nil || incomingPosts.isEmpty) {
                        self.lastPage = self.currentPage
                    }
                    
                    let postsToRender = self.getCurrentPagePosts()
                    
                    self.delegate?.reloadTableWith(posts: postsToRender, isPrevEnabled: isPrevEnabled, isNextEnabled: (self.currentNext != nil) )
                    
                case .failure(let error):
                    print(error)
                }
            }
        }

    }
    
    func getPrevPage() {
        currentPage -= 1
        let postsToRender = getCurrentPagePosts()
        delegate?.reloadTableWith(posts: postsToRender, isPrevEnabled: currentPage != 0, isNextEnabled: true)
    }
    
    private func getCurrentPagePosts() -> [PostCellInfo] {
        let startIndex = Constants.postsLimitPerPage * currentPage
        let endIndex = min((startIndex + (Constants.postsLimitPerPage - 1)), (posts.count - 1))
        let unfilteredPosts = Array(posts[startIndex...endIndex])
        return unfilteredPosts.filter{ !UserDefaults.standard.bool(forKey: "d\($0.id)") }
    }
    
    func dismissPostWith(id: String) {
        userDefaultsManager.dismissPostWith(id: id)
    }
    
    func dismissPosts(posts: [String]) {
        for id in posts {
            userDefaultsManager.dismissPostWith(id: id)
        }
    }
    
    func refreshTable() {
        currentPage = 0
        getTopPosts()
    }
    
    func openImage(forPostId: String) {
        if let post = posts.first(where: { $0.id == forPostId}),
           let url = URL(string: post.thumbnail ?? "") {
            delegate?.openImageWith(url: url)
        }
    }
    
    func save(image: UIImage) {
        if let pngRepresentation = image.pngData() {
            if let filePath = FileHelper.filePath(forKey: "redditThumbnail") {
                do {
                    try pngRepresentation.write(to: filePath, options: .atomic)
                } catch let err {
                    print("Saving file resulted in error: ", err)
                }
            }
        }
    }
}
