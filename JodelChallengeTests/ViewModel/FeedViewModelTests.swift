//
//  FeedViewModelTests.swift
//  JodelChallengeTests
//
//  Created by Henry Chukwu on 26/03/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import XCTest
@testable import JodelChallenge

class FeedViewModelTests: XCTestCase, FeedDelegate {

    private func createViewModel(_ apiClient: FlickrApiProtocol) -> FeedViewModel {
        return FeedViewModel(api: apiClient)
    }
    
    var viewModel: FeedViewModel?

    override func setUpWithError() throws {
        viewModel = createViewModel(FlickrApiTests())
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func test_whenInitialized_storesInitParams() throws {
        
        XCTAssertNotNil(viewModel?.photos)
        XCTAssert(viewModel?.photos.isEmpty == true)
    }

    func test_when_fetchPhotos_getsCalled() {
        viewModel?.fetchPhotos(1, delegate: self)
        XCTAssertEqual(viewModel?.photos.count, 3)
        XCTAssertEqual(viewModel?.photos.first?.title, "JodelChallengeTests")
    }

    func onFetchPhotos() {}
    
    func onError(_ message: String) {}
}
