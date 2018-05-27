//
//  CallManager.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/26/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import Foundation
import CallKit

class CallManager {
    
    private let callController = CXCallController()
    private var currentUUID: UUID?
    
    private func requestTransaction(_ transaction: CXTransaction) {
        callController.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction: \(error)")
            } else {
                print("Requested transaction successfully")
            }
        }
    }
    
    func startCall(handle: String) {
        let handle = CXHandle(type: .phoneNumber, value: handle)
        currentUUID = UUID()
        let startCallAction = CXStartCallAction(call: currentUUID!, handle: handle)
        let transaction = CXTransaction(action: startCallAction)
        
        requestTransaction(transaction)
    }
    
    func end() {
        guard let uuid = currentUUID else { return }
        let endCallAction = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: endCallAction)
        requestTransaction(transaction)
    }
}
