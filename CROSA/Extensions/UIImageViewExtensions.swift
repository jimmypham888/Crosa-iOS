//
//  UIImageViewExtensions.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func changeColorImage(_ color: UIColor) {
        guard let newImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = newImage
        tintColor = color
    }
    
    func setImage(_ urlString: String, placeholder: UIImage? = nil) {
        let options: KingfisherOptionsInfo = [.transition(ImageTransition.fade(0.33))]
        kf.indicatorType = .activity
        kf.setImage(with: URL(string: urlString), placeholder: placeholder, options: options)
    }
}
