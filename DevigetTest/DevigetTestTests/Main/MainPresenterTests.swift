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
    
    
    func testGetFirstPage() {
        //Given
        let mockedVC = MainViewControllerMock()
        let mockedRepository = MainRepositoryMock()
        let mockedUserDefaults = UserDefaultsManagerMock()
        let presenter = MainPresenter(mockedRepository, mockedUserDefaults)
        presenter.delegate = mockedVC
        
        //When
        presenter.getTopPosts()
        
        //Then
        XCTAssert(mockedVC.didCallReloadTable.timesCalled == 1, "Unexpected number of times called 'reloadTable'")
        XCTAssert(mockedVC.isPrevEnabled == false, "Previous page should be disabled")
        XCTAssert(mockedVC.isNextEnabled == true, "Next page should be enabled")
        XCTAssert(mockedVC.posts.count == MainMockedData.firstPagePosts.data.children.count, "Posts mismatch")
        XCTAssert(mockedVC.totalNumberOfCalls() == 1, "Unexpected number of functions called in VC")
        XCTAssert(mockedRepository.totalNumberOfCalls() == 1, "Invalid number of calls to repository")
    }
    
    func testGetNextPageWithRequest() {
        //Given
        let mockedVC = MainViewControllerMock()
        let mockedRepository = MainRepositoryMock()
        let mockedUserDefaults = UserDefaultsManagerMock()
        let presenter = MainPresenter(mockedRepository, mockedUserDefaults)
        presenter.delegate = mockedVC
        
        //When
        presenter.getTopPosts()
        presenter.getNextPage()
        
        //Then
        XCTAssert(mockedVC.didCallReloadTable.timesCalled == 2, "Unexpected number of times called 'reloadTable'")
        XCTAssert(mockedVC.isPrevEnabled == true, "Previous page should be enabled")
        XCTAssert(mockedVC.isNextEnabled == false, "Next page should be disabled")
        XCTAssert(mockedVC.posts.count == MainMockedData.secondPagePosts.data.children.count, "Posts mismatch")
        XCTAssert(mockedVC.totalNumberOfCalls() == 2, "Unexpected number of functions called in VC")
        XCTAssert(mockedRepository.totalNumberOfCalls() == 2, "Invalid number of calls to repository")
    }
    
    func testGetPreviousPage() {
        //Given
        let mockedVC = MainViewControllerMock()
        let mockedRepository = MainRepositoryMock()
        let mockedUserDefaults = UserDefaultsManagerMock()
        let presenter = MainPresenter(mockedRepository, mockedUserDefaults)
        presenter.delegate = mockedVC
        
        //When
        presenter.getTopPosts()
        presenter.getNextPage()
        presenter.getPrevPage()
        
        //Then
        XCTAssert(mockedVC.didCallReloadTable.timesCalled == 3, "Unexpected number of times called 'reloadTable'")
        XCTAssert(mockedVC.isPrevEnabled == false, "Previous page should be disabled")
        XCTAssert(mockedVC.isNextEnabled == true, "Next page should be enabled")
        XCTAssert(mockedVC.posts.count == MainMockedData.firstPagePosts.data.children.count, "Posts mismatch")
        XCTAssert(mockedVC.totalNumberOfCalls() == 3, "Unexpected number of functions called in VC")
        XCTAssert(mockedRepository.totalNumberOfCalls() == 2, "Invalid number of calls to repository")
    }
    
    func testGetNextPageWithoutRequest() {
        //Given
        let mockedVC = MainViewControllerMock()
        let mockedRepository = MainRepositoryMock()
        let mockedUserDefaults = UserDefaultsManagerMock()
        let presenter = MainPresenter(mockedRepository, mockedUserDefaults)
        presenter.delegate = mockedVC

        //When
        presenter.getTopPosts()
        presenter.getNextPage()
        presenter.getPrevPage()
        presenter.getNextPage()

        //Then
        XCTAssert(mockedVC.didCallReloadTable.timesCalled == 4, "Unexpected number of times called 'reloadTable'")
        XCTAssert(mockedVC.isPrevEnabled == true, "Previous page should be enabled")
        XCTAssert(mockedVC.isNextEnabled == false, "Next page should be disabled")
        XCTAssert(mockedVC.posts.count == MainMockedData.secondPagePosts.data.children.count, "Posts mismatch")
        XCTAssert(mockedVC.totalNumberOfCalls() == 4, "Unexpected number of functions called in VC")
        XCTAssert(mockedRepository.totalNumberOfCalls() == 2, "Invalid number of calls to repository")
    }
    
    func testDismissPost() {
        //Given
        let mockedVC = MainViewControllerMock()
        let mockedRepository = MainRepositoryMock()
        let mockedUserDefaults = UserDefaultsManagerMock()
        let presenter = MainPresenter(mockedRepository, mockedUserDefaults)
        presenter.delegate = mockedVC

        //When
        presenter.dismissPostWith(id: "1")
        
        //Then
        XCTAssert(mockedUserDefaults.didCallDismissPost.timesCalled == 1, "Unexpected number of times called 'dismissPost'")
        XCTAssert(mockedUserDefaults.totalNumberOfCalls() == 1, "Unexpected number of times called 'userDefaultsManager'")
    }
    
    func testDismissPosts() {
        //Given
        let mockedVC = MainViewControllerMock()
        let mockedRepository = MainRepositoryMock()
        let mockedUserDefaults = UserDefaultsManagerMock()
        let presenter = MainPresenter(mockedRepository, mockedUserDefaults)
        presenter.delegate = mockedVC

        //When
        presenter.dismissPosts(posts: ["1", "2", "3", "4"])
        
        //Then
        XCTAssert(mockedUserDefaults.didCallDismissPost.timesCalled == 4, "Unexpected number of times called 'dismissPost'")
        XCTAssert(mockedUserDefaults.totalNumberOfCalls() == 4, "Unexpected number of times called 'userDefaultsManager'")
    }
    
    func testReadPost() {
        //Given
        let mockedVC = MainViewControllerMock()
        let mockedRepository = MainRepositoryMock()
        let mockedUserDefaults = UserDefaultsManagerMock()
        let presenter = MainPresenter(mockedRepository, mockedUserDefaults)
        presenter.delegate = mockedVC
        
        //When
        presenter.getTopPosts()
        presenter.readPostWith(id: "1")
        
        //Then
        XCTAssert(mockedVC.didCallReloadTable.timesCalled == 2, "Unexpected number of times called 'reloadTable'")
        XCTAssert(mockedVC.isPrevEnabled == false, "Previous page should be disabled")
        XCTAssert(mockedVC.isNextEnabled == true, "Next page should be enabled")
        XCTAssert(mockedVC.posts.count == MainMockedData.firstPagePosts.data.children.count, "Posts mismatch")
        XCTAssert(mockedVC.posts[0].read == true, "Post should be read")
        XCTAssert(mockedVC.totalNumberOfCalls() == 2, "Unexpected number of functions called in VC")
        XCTAssert(mockedRepository.totalNumberOfCalls() == 1, "Invalid number of calls to repository")
    }
    
    func testRefreshTable() {
        //Given
        let mockedVC = MainViewControllerMock()
        let mockedRepository = MainRepositoryMock()
        let mockedUserDefaults = UserDefaultsManagerMock()
        let presenter = MainPresenter(mockedRepository, mockedUserDefaults)
        presenter.delegate = mockedVC
        
        //When
        presenter.getTopPosts()
        presenter.refreshTable()
        
        //Then
        XCTAssert(mockedVC.didCallReloadTable.timesCalled == 2, "Unexpected number of times called 'reloadTable'")
    }
}
