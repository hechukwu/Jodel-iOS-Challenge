//
//  UICollectionViewCell+NibName.swift
//  JodelChallenge
//
//  Created by Henry Chukwu on 26/03/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import UIKit

public protocol NibLoadable {
    static var reuseIdentifier: String{get}
    static var nibName: String{get}
}

extension NibLoadable where Self: UITableViewCell {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }

    public static var nibName: String {
        return String(describing: self)
    }
}

extension NibLoadable where Self: UICollectionViewCell {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }

    public static var nibName: String {
        return String(describing: self)
    }
}

extension NibLoadable where Self: UITableViewHeaderFooterView {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }

    public static var nibName: String {
        return String(describing: self)
    }
}
