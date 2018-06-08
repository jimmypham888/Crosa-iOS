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
        tap.cancelsTouchesInView = false 
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
    
    internal func successServer(content: String) {
        message(content: content, title: "Thành công")
    }
    
    internal func convertDate(date: String) -> String{
        var stringDate = ""
        if (date == ""){
            stringDate = "--/--"
        }else{
            let dateString = date
            let dateStringArr = dateString.components(separatedBy: " ")
            let day = dateStringArr[0]
            let dateArr = day.components(separatedBy: "-")
            stringDate = dateArr[2] + "/" + dateArr[1]
        }
        return stringDate
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
