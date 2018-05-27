//
//  StringeeManager.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import Foundation

class StringeeManager: NSObject {
    
    static let `shared` = StringeeManager()
    
    private let accessToken: String = ACCESS_TOKEN
    private var stringeeClient: StringeeClient?
    private var stringeeCall: StringeeCall?
    private let callManager = CallManager()
    private let providerDelegate = ProviderDelegate()
    private var currentNumber: String?
    
    private var calling: (() -> ())?
    private var ringing: (() -> ())?
    private var answered: (() -> ())?
    private var busy: (() -> ())?
    private var ended: (() -> ())?
    
    private var callBlock: (() -> ())?
    
    private override init() {
        super.init()
        stringeeClient = StringeeClient(connectionDelegate: self)
    }
    
    func call(number: String,
              calling: @escaping () -> (),
              ringing: @escaping () -> (),
              answered: @escaping () -> (),
              busy: @escaping () -> (),
              ended: @escaping () -> ()) {
        guard let stringeeClient = stringeeClient else { return }
        callBlock = nil
        
        self.calling = calling
        self.ringing = ringing
        self.answered = answered
        self.busy = busy
        self.ended = ended
        
        currentNumber = number
        if stringeeClient.hasConnected {
            stringeeCall = StringeeCall(stringeeClient: stringeeClient, from: "84901701061", to: number)
            stringeeCall?.delegate = self
            stringeeCall?.make(completionHandler: { (status, code, message) in
                print("Make call result: \(code.description), message: \(message?.description ?? "")")
            })
        } else {
            callBlock = {
                self.stringeeCall = StringeeCall(stringeeClient: stringeeClient, from: "84901701061", to: number)
                self.stringeeCall?.delegate = self
                self.stringeeCall?.make(completionHandler: { (status, code, message) in
                    print("Make call result: \(code.description), message: \(message?.description ?? "")")
                })
            }
            stringeeClient.connect(withAccessToken: accessToken)
        }
        
    }
    
    private func connect() {
        guard let stringeeClient = stringeeClient else {
            return
        }
        
        stringeeClient.connect(withAccessToken: accessToken)
    }
    
    private func disconnect() {
        guard let stringeeClient = stringeeClient else { return }
        stringeeClient.disconnect()
        currentNumber = nil
        calling = nil
        ringing = nil
        answered = nil
        busy = nil
        ended = nil
    }
    
    func endCall() {
        stringeeCall?.hangup(completionHandler: { (status, code, message) in
            print("Hangup result: \(code.description), message: \(message?.description ?? "")")
            self.callManager.end()
            self.disconnect()
        })
    }
}

extension StringeeManager: StringeeCallDelegate {
    func didChangeSignalingState(_ stringeeCall: StringeeCall!, signalingState: SignalingState, reason: String!, sipCode: Int32, sipReason: String!) {
        guard let currentNumber = currentNumber else { return }
        switch signalingState {
        case .calling:
            callManager.startCall(handle: currentNumber)
            calling?()
        case .ringing:
            ringing?()
        case .answered:
            answered?()
        case .busy:
            busy?()
            callManager.end()
            disconnect()
        case .ended:
            ended?()
            callManager.end()
            disconnect()
        }
    }
    
    func didChangeMediaState(_ stringeeCall: StringeeCall!, mediaState: MediaState) {
    }
}

extension StringeeManager: StringeeConnectionDelegate {
    func requestAccessToken(_ stringeeClient: StringeeClient!) {
        print("requestAccessToken")
    }
    
    func didConnect(_ stringeeClient: StringeeClient!, isReconnecting: Bool) {
        print("Successfully connected to Stringee Server, user ID: \(stringeeClient.userId)")
        callBlock?()
    }
    
    func didDisConnect(_ stringeeClient: StringeeClient!, isReconnecting: Bool) {
        print("didDisConnect")
    }
    
    func didFailWithError(_ stringeeClient: StringeeClient!, code: Int32, message: String!) {
        print("Failed connection to Stringee Server with error: \(message)")
    }
}
