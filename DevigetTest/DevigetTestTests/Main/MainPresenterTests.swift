//
//  MainPresenterTests.swift
//  DevigetTestTests
//
//  Created by Rodrigo Camparo on 03/02/2021.
//

import Foundation
import XCTest
@testable import DevigetTest

class MainPresenterTests: XCTestCase {
    
    
    func testGetFirstNTopPosts() {
        //Given
        let mockedVC = MainViewControllerMock()
        let mockedRepository = MainRepositoryMock()
        let presenter = MainPresenter(mockedRepository)
        presenter.delegate = mockedVC
        
        //When
        presenter.getTopPosts()
        
        //Then
        XCTAssert(mockedVC.didCallReloadTable.timesCalled == 1, "Unexpected number of times called 'reloadTable'")
        XCTAssert(mockedVC.isPrevEnabled == false, "Previous page should be disabled")
        XCTAssert(mockedVC.isNextEnabled == true, "Next page should be enabled")
    }
}
