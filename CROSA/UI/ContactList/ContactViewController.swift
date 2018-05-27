//
//  ContactViewController.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit
import SVProgressHUD

class ContactViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContact()
    }
    
    private func loadContact() {
        SVProgressHUD.show()
        Contact.get(id: 1, success: { (contacts) in
            SVProgressHUD.dismiss()
            print(contacts)
        }) {
            SVProgressHUD.dismiss()
            self.errorServer(content: $0)
        }
    }

}
