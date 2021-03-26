//
//  FlickrApiTests.swift
//  JodelChallengeTests
//
//  Created by Henry Chukwu on 26/03/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation
@testable import JodelChallenge

class FlickrApiTests: FlickrApiProtocol {
    func fetchPhotos(withCompletion completion: @escaping ([URL]?, Error?) -> Void) {
        completion(TestData.photoUrlArray, nil)
    }
}
