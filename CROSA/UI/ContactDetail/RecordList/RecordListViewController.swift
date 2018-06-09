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
import SwiftySound

class RecordListViewController: BaseViewController {
    
    private let historyCall: HistoryCall
    private var player: Sound!
    private var isPlayingCurrent = false
    private var currentIndex:Int = 0
    
    @IBOutlet weak var callDateLbl: UITextField!
    @IBOutlet weak var callScheduleLbl: UITextField!
    @IBOutlet weak var levelLbl: UITextField!
    @IBOutlet weak var contentTv: UITextView!
    @IBOutlet weak var mediaButton: UIButton!
    
    
    init(record: HistoryCall) {
        historyCall = record
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.dismiss()
        updateView()
        startDownload(audioUrl: historyCall.linkDownRecord)
    }
    
    func updateView() {
        callDateLbl.text = historyCall.startTime
        callScheduleLbl.text = historyCall.call_schedule
        levelLbl.text = historyCall.current_level
        contentTv.text = historyCall.comment
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(player.playing){
            player.stop()
        }
        isPlayingCurrent = false
    }
    
    @IBAction func playRecord(_ sender: UIButton) {
        
        if (isPlayingCurrent == true){
            pause()
            mediaButton.setTitle("Play", for: .normal)
        }else{
            play()
            mediaButton.setTitle("Pause", for: .normal)
        }
        isPlayingCurrent = !isPlayingCurrent
    }
}


extension RecordListViewController {
    func play() {
        
        guard let player = player else { return }
        if !player.resume() {
            player.play(numberOfLoops: 0)
        }

    }
    
    func pause() {
        player.pause()
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
                    self.player = Sound(url: destinationUrl)
                    self.player.prepare()
                    self.player!.volume = 1.0
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
