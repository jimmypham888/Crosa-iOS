//
//  CallKitDemoViewController.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/26/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit
import CallKit

class CallKitDemoViewController: UIViewController {
    
    init() {
        super.init(nibName: "CallKitDemoViewController", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let configuration = CXProviderConfiguration(localizedName: "Crosa")
        let provider = CXProvider(configuration: configuration)
        provider.setDelegate(self, queue: nil)
        let controller = CXCallController()
        let startCallAction = CXStartCallAction(call: UUID(), handle: CXHandle(type: .generic, value: "Pete Za"))
        let transaction = CXTransaction(action: startCallAction)
        controller.request(transaction, completion: { _ in })
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 5) {
            provider.reportOutgoingCall(with: controller.callObserver.calls[0].uuid, connectedAt: nil)
        }
    }
    
}

extension CallKitDemoViewController: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        
    }
}
