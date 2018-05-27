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
    
    @IBOutlet weak var leftBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContact()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItem(leftBtn)
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
