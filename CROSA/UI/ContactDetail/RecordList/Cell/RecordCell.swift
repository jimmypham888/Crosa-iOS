//
//  RecordCell.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/31/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit

class RecordCell: BaseTableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var noLbl: UILabel!
    
    private var didTapPlay: (() -> ())?
    
    @IBAction func didTapPlay(_ sender: Any) {
        didTapPlay?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        didTapPlay = nil
    }

    func updateWith(historyCall: HistoryCall, index: Int, action: @escaping (() -> ())) {
        dateLbl.text = historyCall.startTime
        noLbl.text = index.description
        didTapPlay = action
    }
}
