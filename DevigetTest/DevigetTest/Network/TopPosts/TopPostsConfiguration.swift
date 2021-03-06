//
//  TopPostsConfiguration.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import Foundation

enum TopPostsConfigurations {
    case getTopPosts(limit: Int)
    case getNextTopPosts(limit: Int, after: String)
}

extension TopPostsConfigurations: NetworkConfiguration {
    var path: String {
        return "/r/subreddit/top.json"
    }
    
    var httpMethod: HttpMethod {
        .get
    }
    
    var additionalHeaders: HTTPHeaders? {
        nil
    }
    
    var parameters: Parameters? {
        switch self {
        case .getTopPosts(let limit):
            return ["limit": limit, "t": "all"]
        case .getNextTopPosts(let limit, let after):
            return ["limit": limit, "after": after, "t": "all"]
        }
    }
    
    var needAuthentication: Bool {
        false
    }
    
    
}
