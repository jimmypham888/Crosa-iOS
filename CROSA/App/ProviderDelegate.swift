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
        let providerConfiguration = CXProviderConfiguration(localizedName: "Crosa")
        
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        
        return providerConfiguration
    }
}

extension ProviderDelegate: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        print("Provider did reset")
        stopAudio()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        let call = Call(uuid: action.callUUID, handle: action.handle.value)
        // 1.
        configureAudioSession()
        provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: nil)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        stopAudio()
        action.fulfill()
    }
}
