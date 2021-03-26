//
//  TestData.swift
//  JodelChallengeTests
//
//  Created by Henry Chukwu on 26/03/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import XCTest
@testable import JodelChallenge

class TestData {

    static let photoUrl: URL? = URL(string: "https://farm66.static.flickr.com/65535/50999206525_8d402b9f27_m.jpg")

    static var photoUrlArray: [URL] {
        var urlArr = [URL]()
        for _ in 1...3 {
            urlArr.append(photoUrl!)
        }
        return urlArr
    }
}
