//
//  UIViewExtensions.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit

extension UIView {
    func makeCircle() {
        layer.cornerRadius = bounds.size.width / 2.0
        clipsToBounds = true
    }
    
    static func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    static func loadNib() -> Self {
        return loadNib(self)
    }
    
    func addSubviews(_ views: UIView...) {
        for v in views {
            addSubview(v)
        }
    }
}
