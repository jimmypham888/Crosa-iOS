//
//  HistoryCall.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/30/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import ObjectMapper

class HistoryCall: ImmutableMappable {
    
    let callId: String
    let mobilePhone: String
    let startTime: String
    let linkDownRecord: String
    
    required init(map: Map) throws {
        callId = try map.value("call_id")
        mobilePhone = try map.value("mobile_phone")
        startTime = try map.value("start_time")
        linkDownRecord = try map.value("link_down_record")
    }
}
