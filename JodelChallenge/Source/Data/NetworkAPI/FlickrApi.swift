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

protocol FlickrApiProtocol {
    func fetchPhotos(withCompletion completion: @escaping ([URL]?, Error?) -> Void)
}

class FlickrApi: NSObject, FlickrApiProtocol {
    func fetchPhotos(withCompletion completion: @escaping ([URL]?, Error?) -> Void) {
        let fk = FlickrKit.shared()

        fk.initialize(withAPIKey: FLICKR_API_KEY, sharedSecret: FLICKR_SHARED_SECRET)

        let interesting = FKFlickrInterestingnessGetList()
        interesting.per_page = "10"
        
        fk.call(interesting) { response, error in
            if let response = response {
                var photoURLs = [URL]()
                let topPhotos = response["photos"] as? [AnyHashable: Any]
                if let value = topPhotos?["photo"] as? [[AnyHashable: Any]] {
                    for photoData in value {
                        let url = fk.photoURL(for: .small240, fromPhotoDictionary: photoData)
                        print("url===\(url)")
                        photoURLs.append(url)
                    }
                    completion(photoURLs, nil)
                }
            } else {
                completion(nil, error)
            }
        }
    }
}
