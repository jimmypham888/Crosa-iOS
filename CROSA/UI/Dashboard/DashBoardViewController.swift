//
//  DashBoardViewController.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit

class DashBoardViewController: BaseViewController {

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var stockBtn: UIButton!
    @IBOutlet weak var needBtn: UIButton!
    
    private let userId: Int
    
    init(userId: Int) {
        self.userId = userId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var leftBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remakeWrapperView(wrapperView)
        setNavigationBarItem(leftBtn)
        nameLbl.text = AccountAuth.default.name
        emailLbl.text = AccountAuth.default.email
    }

    @IBAction func didTapGoToListContact(_ sender: UIButton) {
        navigationController?.pushViewController(ContactViewController(contactId: userId, type: 2), animated: true)
    }
    
    @IBAction func didTapGoToStock(_ sender: Any) {
    navigationController?.pushViewController(ContactViewController(contactId: userId, type: 1), animated: true)
    }
    
    @IBAction func didTapGotoPhoneCall(_ sender: Any) {
        navigationController?.pushViewController(ContactViewController(contactId: userId, type: 0), animated: true)
    }
}
