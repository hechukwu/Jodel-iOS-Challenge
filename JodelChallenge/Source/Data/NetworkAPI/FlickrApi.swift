//
//  FlickrApi.swift
//  JodelChallenge
//
//  Created by Henry Chukwu on 26/03/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation
import UIKit
import FlickrKit

let fk = FlickrKit.shared()

protocol FlickrApiProtocol {
    func fetchPhotos(_ page: Int, withCompletion completion: @escaping (PhotosClass?, Error?) -> Void)
}

class FlickrApi: NSObject, FlickrApiProtocol {
    
    // MARK: Private Instance Property
    
    private let interesting = FKFlickrInterestingnessGetList()

    // MARK: class initializer

    override init() {
        fk.initialize(withAPIKey: FLICKR_API_KEY, sharedSecret: FLICKR_SHARED_SECRET)
        self.interesting.per_page = "10"
    }

    // MARK: Internal method

    func fetchPhotos(_ page: Int, withCompletion completion: @escaping (PhotosClass?, Error?) -> Void) {

        interesting.page = "\(page)"
        
        fk.call(interesting) { response, error in
            if let response = response {
                let flickrResult = JSONDecoder().decode(Photos.self, from: response)
                completion(flickrResult?.photos, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
