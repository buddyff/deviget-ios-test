//
//  MainRepository.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import Foundation

final class MainRepository {
    
    let connector: NetworkConnector = NetworkConnector<TopPostsConfigurations, PostList>()
    
    func getTopPosts(callback: @escaping (Result<PostList>) -> Void) {
        
        connector.request(TopPostsConfigurations.getTopPosts(limit: 10)) { (result) in
            switch result {
            case .success(let response):
                callback(Result.success(response))
            case .failure(let error):
                print("ERROR GETTING TOP POSTS: \(error)")
                callback(Result.failure(error))
            }
        }
        
    }
    
}
