//
//  ContactTableViewCell.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit

class ContactTableViewCell: BaseTableViewCell {
    
    private var actionHandle: (() -> ())?
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var telLbl: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBAction func didTap(_ sender: UIButton) {
        actionHandle?()
    }
    
    func updateWithContact(_ contact: Contact, index: Int, actionHandle: @escaping (() -> ())) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"
        numberLbl.text = index.description
        nameLbl.text = contact.name
        telLbl.text = contact.phone
        emaillbl.text = contact.email
        levelLbl.text = "L\(contact.currentLevel!)"
        if (contact.dateLastCall != nil){
            dateLbl.text = convertDate(date: contact.dateLastCall!, type: 0)
        }else{
            dateLbl.text = "--/--"
        }
        if (contact.comment != nil){
           statusLbl.text = contact.comment
        }else{
            statusLbl.text = ""
        }
        
        self.actionHandle = actionHandle
    }

}
