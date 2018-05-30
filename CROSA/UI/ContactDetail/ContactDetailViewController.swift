//
//  ContactDetailViewController.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit
import SVProgressHUD

class ContactDetailViewController: BaseViewController {

    @IBOutlet weak var wrapperView: UIView!
    
    private let contact: Contact
    private var historyCall: [HistoryCall] = []
    @IBOutlet weak var callState: UILabel!
    
    init(withContact contact: Contact) {
        self.contact = contact
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    
    @IBOutlet weak var callBtn: UIButton!
    
    @IBAction func didTapShowListRecord(_ sender: UIButton) {
        SVProgressHUD.show()
        contact.getRecord(success: { (historyCall) in
            SVProgressHUD.dismiss()
            self.historyCall.append(contentsOf: historyCall)
        }) {
            SVProgressHUD.dismiss()
            self.errorServer(content: $0)
        }
    }
    
    @IBAction func didTapCall(_ sender: UIButton) {
        if isCalling {
            // End call
            isCalling = false
            StringeeManager.shared.endCall()
            self.callState.text = "Kết thúc cuộc gọi"
            return
        }
        
        guard let phone = phoneTf.text, phone != "" else { return }
        
        isCalling = true
        StringeeManager.shared.call(number: phone, calling: {
            self.callState.text = "Đang gọi..."
        }, ringing: {
            self.callState.text = "Đang đổ chuông..."
        }, answered: {
            self.callState.text = "Đang kết nối"
        }, busy: {
            self.callState.text = "Số máy bận"
            self.isCalling = false
        }) {
            self.callState.text = "Kết thúc cuộc gọi"
            self.isCalling = false
        }
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private var isCalling: Bool = false {
        didSet {
            callBtn.setTitle(isCalling ? "Huỷ" : "Gọi", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remakeWrapperView(wrapperView)
        updateView()
    }
    
    private func updateView() {
        nameTf.text = contact.name
        phoneTf.text = contact.phone
        emailTf.text = contact.email
    }

}
