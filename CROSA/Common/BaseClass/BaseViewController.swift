//
//  BaseViewController.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit
import SVProgressHUD
import SnapKit

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: String.className(type(of: self)), bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setEndEditing() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    internal func remakeWrapperView(_ wrapperView: UIView) {
        if ProcessInfo.isOperatingSystemBelowVersion(11) {
            wrapperView.removeFromSuperview()
            view.addSubview(wrapperView)
            wrapperView.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(topLayoutGuide.snp.bottom)
                $0.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
    
    internal func errorServer(content: String) {
        message(content: content, title: "Lỗi")
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
