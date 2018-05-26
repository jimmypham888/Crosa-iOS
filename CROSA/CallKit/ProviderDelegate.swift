//
//  ProviderDelegate.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/24/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import CallKit

class ProviderDelegate: NSObject {
    
    private let provider: CXProvider
    
    override init() {
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
        super.init()
        
        provider.setDelegate(self, queue: nil)
    }
    
    static var providerConfiguration: CXProviderConfiguration {
        let providerConfiguration = CXProviderConfiguration(localizedName: "Hotline")
        
        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        
        return providerConfiguration
    }
    
    func reportIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)?) {
        // 1.
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        update.hasVideo = hasVideo
        
        // 2.
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if error == nil {
                // 3.
                let call = Call(uuid: uuid, handle: handle)
                self.callManager.add(call: call)
            }
            
            // 4.
            completion?(error as? NSError)
        }
    }
}

extension ProviderDelegate: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        
    }
}
