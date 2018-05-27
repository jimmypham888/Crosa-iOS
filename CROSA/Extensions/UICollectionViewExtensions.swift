//
//  UICollectionViewExtensions.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(type cellType: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, for indexPath: IndexPath) -> T where T: ReusableView, T: NibLoadableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

