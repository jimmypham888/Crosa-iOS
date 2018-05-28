//
//  LoginViewController.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: BaseViewController {

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setEndEditing()
        remakeWrapperView(wrapperView)
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        guard let email = emailTf.text, let password = passwordTf.text else { return }
        SVProgressHUD.show()
        Account.login(username: email, password: password, success: { (account) in
            SVProgressHUD.dismiss()
            AccountAuth.default.updateAccount(account: account)
            AppDelegate.shared.loginSuccess()
        }) {
            SVProgressHUD.dismiss()
            self.errorServer(content: $0)
        }
    }
    
}
