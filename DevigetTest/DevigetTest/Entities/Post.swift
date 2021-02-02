//
//  Post.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import Foundation

struct PostList: Decodable {
    var data: PostListData
}

struct PostListData: Decodable {
    var children: [Post]
    var after: String?
    var before: String?
}

struct Post: Decodable {
    var data: PostData
}

struct PostData: Decodable {
    var author: String
    var title: String
    var comments: Int
    var thumbnail: String?
    var created: Float
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case author
        case title
        case comments = "num_comments"
        case thumbnail
        case created = "created_utc"
        case id
    }
}
