//
//  FeedCell.swift
//  JodelChallenge
//
//  Created by Henry Chukwu on 26/03/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell, NibLoadable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 8
    }

    public func configure(with photo: Photo) {
        imageTitle.text = photo.title
        DispatchQueue.global(qos: .background).async {
            if let imageUrl = photo.getImagePath(), let data = try? Data(contentsOf: imageUrl) {
                let image = UIImage(data: data)
                DispatchQueue.main.async(execute: {
                    self.imageView.image = image
                })
            }
        }
    }

}
