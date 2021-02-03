//
//  MainMockedData.swift
//  DevigetTestTests
//
//  Created by Rodrigo Camparo on 03/02/2021.
//

import Foundation
@testable import DevigetTest

struct MainMockedData {
    
    static let firstPagePosts = PostList(
        data: PostListData(
            children: [
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "1")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "2")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "3")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "4")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "5")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "6")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "7")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "8")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "9")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "10")),
            ],
            after: "11",
            before: nil
        )
    )
    
    static let secondPagePosts = PostList(
        data: PostListData(
            children: [
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "11")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "12")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "13")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "14")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "15")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "16")),
                Post(data: PostData(author: "Rodrigo", title: "TestPost", comments: 0, thumbnail: nil, created: 10000000.1, id: "17"))
            ],
            after: nil,
            before: nil
        )
    )
    
    
}
