//
//  RecordListViewController.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/31/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class RecordListViewController: BaseViewController {

    @IBOutlet weak var recordList: UITableView!
    
    private let historyCalls: [HistoryCall]
    private var player: AVPlayer?
    
    init(record: [HistoryCall]) {
        historyCalls = record
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
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
        cell.updateWith(historyCall: historyCall, index: indexPath.row + 1) {
            self.startDownload(audioUrl: historyCall.linkDownRecord)
        }
        return cell
    }
}

extension RecordListViewController {
    func play(urlString: URL) {
        player = AVPlayer(url: urlString)
        player!.volume = 1.0
        player!.play()
    }
    
    func startDownload(audioUrl: String) -> Void {
        
        let fileUrl = self.getSaveFileUrl(fileName: audioUrl)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        SVProgressHUD.show()
        Alamofire.download(audioUrl, headers: ["X-STRINGEE-AUTH": ACCESS_TOKEN], to:destination)
            .downloadProgress { (progress) in
                print(progress.fractionCompleted)
            }
            .responseData { (data) in
                SVProgressHUD.dismiss()
                if let destinationUrl = data.destinationURL {
                    self.play(urlString: destinationUrl)
                } else {
                    self.errorServer(content: "Network error!")
                }
        }
    }
    
    func getSaveFileUrl(fileName: String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let nameUrl = URL(string: fileName)
        let fileURL = documentsURL.appendingPathComponent("\(nameUrl?.lastPathComponent ?? "").mp3")
        
        NSLog(fileURL.absoluteString)
        return fileURL;
    }
}
