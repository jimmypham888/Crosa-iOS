//
//  ContactAPI.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import Alamofire

class ContactAPI: AbstractAPI {
    
    static func get(id: Int) -> AlamofireImmutableModelArrayTask<Contact>.T {
        let params: Parameters = [
            "id_user_tvts": "\(id)"
        ]
        return createModelArrayTask(API.listContact, parameters: params)
    }
    
    static func getPending(id: String, level: String) -> AlamofireImmutableModelArrayTask<Contact>.T {
        let params: Parameters = [
            "id_user_tvts": id,
            "current_level": level
        ]
        return createModelArrayTask(API.pendingContact, parameters: params)
    }
    
    static func getStock(id: String) -> AlamofireImmutableModelArrayTask<Contact>.T {
        let params: Parameters = [
            "id_user_tvts": id
        ]
        return createModelArrayTask(API.stockContact, parameters: params)
    }
    
    static func get(phoneNumber: String) -> AlamofireImmutableModelArrayTask<HistoryCall>.T {
        let params: Parameters = [
            "mobile_phone": phoneNumber
        ]
        return createModelArrayTask(API.getAllHistoryCall, parameters: params)
    }
    
    static func update(id: String, name: String, email:String) -> AlamofireJsonTask {
        let params: Parameters = [
            "id": id,
            "name": name,
            "email": email
        ]
        return createJSONTask(API.updateContact, parameters: params)
    }
    
    static func updateFull(id: String, name: String, email:String, level:String, call_id:String, callBackTime: String, comment:String) -> AlamofireJsonTask {
        let params: Parameters = [
            "id": id,
            "name": name,
            "email": email,
            "current_level": level,
            "call_id": call_id,
            "call_schedule": callBackTime,
            "comment": comment,
        ]
        return createJSONTask(API.updateHistoryCall, parameters: params)
    }
}
