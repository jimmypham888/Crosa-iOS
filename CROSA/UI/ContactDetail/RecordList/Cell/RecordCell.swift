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
    @IBOutlet weak var dateCallLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    
    
    private var isPlaying = true
    
    private var didTapPlay: (() -> ())?
    
    @IBAction func didTapPlay(_ sender: Any) {
        isPlaying = !isPlaying
//        mediaBtn.setTitle(isPlaying ? "Play" : "Pause", for: .normal)
        didTapPlay?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        didTapPlay = nil
    }

    func updateWith(historyCall: HistoryCall, index: Int, action: @escaping (() -> ())) {
        dateCallLbl.text = convertDate(date: historyCall.startTime, type: 1)
        dateLbl.text = convertDate(date: historyCall.startTime, type: 2)
        didTapPlay = action
    }
}
