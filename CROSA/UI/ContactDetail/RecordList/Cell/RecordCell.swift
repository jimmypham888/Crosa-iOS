//
//  RecordCell.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/31/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit

class RecordCell: BaseTableViewCell {

    @IBOutlet weak var mainLbl: UILabel!
    
    private var didTapPlay: (() -> ())?
    
    @IBAction func didTapPlay(_ sender: Any) {
        didTapPlay?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        didTapPlay = nil
    }

    func updateWith(historyCall: HistoryCall, action: @escaping (() -> ())) {
        mainLbl.text = historyCall.startTime
        didTapPlay = action
    }
}
