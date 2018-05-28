//
//  LeftMenuViewController.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit

class LeftMenuViewController: BaseViewController {

    @IBOutlet weak var logoutImage: UIImageView!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var email: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remakeWrapperView(wrapperView)
        logoutImage.changeColorImage(#colorLiteral(red: 0.8666666667, green: 0.5607843137, blue: 0.1647058824, alpha: 1))
        
        fullname.text = AccountAuth.default.name
        email.text = AccountAuth.default.email
    }

    @IBAction func didTapLogout(_ sender: Any) {
        AccountAuth.default.logout()
        AppDelegate.shared.logout()
    }
}
