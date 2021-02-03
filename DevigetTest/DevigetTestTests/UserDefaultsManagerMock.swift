//
//  UserDefaultsManagerMock.swift
//  DevigetTestTests
//
//  Created by Rodrigo Camparo on 03/02/2021.
//

import Foundation
@testable import DevigetTest

class UserDefaultsManagerMock: Mock, UserDefaultsProtocol  {
    
    var didCallReadPost: MockCounter = MockCounter()
    var didCallDismissPost: MockCounter = MockCounter()
    
    func readPostWith(id: String) {
        didCallReadPost.wasCalled()
    }
    
    func dismissPostWith(id: String) {
        didCallDismissPost.wasCalled()
    }
    
    
}
