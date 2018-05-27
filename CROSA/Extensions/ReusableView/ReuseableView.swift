//
//  ReuseableView.swift
//  EduMall
//
//  Created by Jimmy Pham on 4/20/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import Foundation

import UIKit

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
