//
//  MainViewControllerMock.swift
//  DevigetTestTests
//
//  Created by Rodrigo Camparo on 03/02/2021.
//

import Foundation
@testable import DevigetTest

class MainViewControllerMock: Mock, MainProtocol {
    
    var didCallReloadTable = MockCounter()
    var posts: [PostCellInfo] = []
    var isPrevEnabled: Bool?
    var isNextEnabled: Bool?
    
    func reloadTableWith(posts: [PostCellInfo], isPrevEnabled: Bool, isNextEnabled: Bool) {
        self.posts = posts
        self.isPrevEnabled = isPrevEnabled
        self.isNextEnabled = isNextEnabled
        didCallReloadTable.wasCalled()
    }
    
    
}
