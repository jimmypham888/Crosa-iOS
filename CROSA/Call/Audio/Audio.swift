//
//  Audio.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/26/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import AVFoundation

func configureAudioSession() {
    print("Configuring audio session")
    let session = AVAudioSession.sharedInstance()
    do {
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try session.setMode(AVAudioSessionModeVoiceChat)
    } catch (let error) {
        print("Error while configuring audio session: \(error)")
    }
}

func startAudio() {
    print("Starting audio")
}

func stopAudio() {
    print("Stopping audio")
}
