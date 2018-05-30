//
//  RecordListViewController.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/31/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit

class RecordListViewController: BaseViewController {

    @IBOutlet weak var recordList: UITableView!
    
    private let historyCalls: [HistoryCall]
    
    init(record: [HistoryCall]) {
        historyCalls = record
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recordList.dataSource = self
        recordList.registerCell(type: RecordCell.self)
        recordList.separatorStyle = .none
    }
    
}

extension RecordListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyCalls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: RecordCell.self, for: indexPath)
        let historyCall = historyCalls[indexPath.row]
        cell.updateWith(historyCall: historyCall) {
            print(historyCall.linkDownRecord)
        }
        return cell
    }
}
