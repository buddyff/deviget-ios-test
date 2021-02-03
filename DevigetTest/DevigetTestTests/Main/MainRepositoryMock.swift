//
//  MainRepositoryMock.swift
//  DevigetTestTests
//
//  Created by Rodrigo Camparo on 03/02/2021.
//

import Foundation
@testable import DevigetTest

class MainRepositoryMock: MainRepositoryProtocol, Mock {
    
    var didCallGetTopsPosts: MockCounter = MockCounter()
    var didCallNextTopsPosts: MockCounter = MockCounter()
    
    func getTopPosts(callback: @escaping (Result<PostList>) -> Void) {
        didCallGetTopsPosts.wasCalled()
        callback(Result.success(MainMockedData.firstPagePosts))
    }
    
    func getNextTopPosts(after: String, callback: @escaping (Result<PostList>) -> Void) {
        didCallNextTopsPosts.wasCalled()
        callback(Result.success(MainMockedData.secondPagePosts))
    }
    
    
}
