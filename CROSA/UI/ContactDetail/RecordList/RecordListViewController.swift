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
import AVFoundation

class RecordListViewController: BaseViewController {
    
    let timeFormatter = NumberFormatter()
    
    var audioPlayer: AVAudioPlayer?     // holds an audio player instance. This is an optional!
    var audioTimer: Timer?            // holds a timer instance
    var isDraggingTimeSlider = false    // Keep track of when the time slide is being dragged
    
    var isPlaying = false {             // keep track of when the player is playing
        didSet {                        // This is a computed property. Changing the value
            setButtonState()            // invokes the didSet block
            playPauseAudio()
        }
    }
    
    private let historyCall: HistoryCall
    private var player: Sound!

    
    @IBOutlet weak var callDateLbl: UITextField!
    @IBOutlet weak var callScheduleLbl: UITextField!
    @IBOutlet weak var levelLbl: UITextField!
    @IBOutlet weak var contentTv: UITextView!
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var audioTimerLbl: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    
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
        SVProgressHUD.dismiss()
        updateView()
        startDownload(audioUrl: historyCall.linkDownRecord)
    }
    
    func updateView() {
        callDateLbl.text = convertDate(date: historyCall.startTime, type: 2)
        if (historyCall.call_schedule != nil){
            callScheduleLbl.text = convertDate(date: historyCall.call_schedule!, type: 2)
        }
//        if (historyCall.call_schedule != nil){
//            callScheduleLbl.text = convertDate(date: historyCall.call_schedule!, type: 2)
//        }
        levelLbl.text = "L\(historyCall.current_level?.description ?? "")"
        contentTv.text = historyCall.comment
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
                if(audioPlayer?.isPlaying)!{
                    audioPlayer?.stop()
                }
                isPlaying = false
    }
    
    @IBAction func playRecord(_ sender: UIButton) {
        
        isPlaying = !isPlaying
    }
}


extension RecordListViewController {
//    func play() {
//
//        guard let player = player else { return }
//        if !player.resume() {
//            player.play(numberOfLoops: 0)
//        }
//
//    }
//
//    func pause() {
//        player.pause()
//    }
    
    
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
//                    self.player = Sound(url: destinationUrl)
//                    self.player.prepare()
//                    self.player!.volume = 1.0
                    self.audioPlayer = try! AVAudioPlayer(contentsOf: destinationUrl as URL)
                    self.makeTimer()
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

extension RecordListViewController{
    
    // Formatting time for display
    
    
    @IBAction func timeSliderChanged(sender: UISlider) {
        // Working on this
        // TODO: Implement Time Slider
        guard let audioPlayer = audioPlayer else {
            return
        }
        
        audioPlayer.currentTime = audioPlayer.duration * Double(sender.value)
    }
    
    // The time slider is tricky since we want it to update while the player is playing
    // but it can't be updated while we dragging it!
    @IBAction func timeSliderTouchDown(sender: UISlider) {
        isDraggingTimeSlider = true
    }
    
    @IBAction func timeSliderTouchUp(sender: UISlider) {
        isDraggingTimeSlider = false
    }
    
    @IBAction func timeSliderTouchUpOutside(sender: UISlider) {
        isDraggingTimeSlider = false
    }
    
    enum PlayState: String {
        case Play = "Play"
        case Puase = "Pause"
    }
    
    func setButtonState() {
        // When the play button is tapped the text changes
        // TODO: Use the enum below for button and player states
        if isPlaying {
            mediaButton.setTitle("Pause", for: .normal)
        } else {
            mediaButton.setTitle("Play", for: .normal)
        }
    }
    
    func playPauseAudio() {
        // audioPlayer is optional use guard to check it before using it.
        guard let audioPlayer = audioPlayer else {
            return
        }
        
        // Check is playing then play or pause
        if isPlaying {
            audioPlayer.play()
        } else {
            audioPlayer.pause()
        }
    }
    
    func makeTimer() {
        // This function sets up the timer.
        if audioTimer != nil {
            audioTimer!.invalidate()
        }
        
        // audioTimer = Timer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.onTimer(_:)), userInfo: nil, repeats: true)
        
        audioTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func onTimer(timer: Timer) {
        // Check the audioPlayer, it's optinal remember. Get the current time and duration
        guard let currentTime = audioPlayer?.currentTime, let duration = audioPlayer?.duration else {
            return
        }
        
        // Calculate minutes, seconds, and percent completed
        let mins = currentTime / 60
        // let secs = currentTime % 60
        let secs = currentTime.truncatingRemainder(dividingBy: 60)
        let percentCompleted = currentTime / duration
        
        // Use the number formatter, it might return nil so guard
        //    guard let minsStr = timeFormatter.stringFromNumber(NSNumber(mins)), let secsStr = timeFormatter.stringFromNumber(NSNumber(secs)) else {
        //      return
        //    }
        
        guard let minsStr = timeFormatter.string(from: NSNumber(value: mins)), let secsStr = timeFormatter.string(from: NSNumber(value: secs)) else {
            return
        }
        
        
        // Everything is cool so update the timeLabel and progress bar
        audioTimerLbl.text = "\(minsStr):\(secsStr)"
//        progressBar.progress = Float(percentCompleted)
        // Check that we aren't dragging the time slider before updating it
        if !isDraggingTimeSlider {
            timeSlider.value = Float(percentCompleted)
        }
    }
    
    
}
