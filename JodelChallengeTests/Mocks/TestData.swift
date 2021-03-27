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

    static let photo: Photo = Photo(id: "23451156376",
                                    owner: "28017113@N08",
                                    secret: "8983a8ebc7",
                                    server: "578",
                                    farm: 1,
                                    title: "JodelChallengeTests",
                                    ispublic: 1,
                                    isfriend: 0,
                                    isfamily: 0)

    static var photoArray: [Photo] {
        var photoArr = [Photo]()
        for _ in 1...3 {
            photoArr.append(photo)
        }
        return photoArr
    }
}
