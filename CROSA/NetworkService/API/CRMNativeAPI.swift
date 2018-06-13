//
//  CRMNativeAPI.swift
//  CROSA
//
//  Created by Macbook on 6/13/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import Alamofire

class CRMNativeAPI: AbstractAPI {
    static func bookAccount(id_contact: String) -> AlamofireJsonTask {
        let params: Parameters = [
            "id_contact": id_contact
        ]
        return createJSONTask(API.bookAcc, parameters: params)
    }
    
    static func getAccountNativeTest(id_contact: String) -> AlamofireJsonTask {
        let params: Parameters = [
            "id_contact": id_contact
        ]
        return createJSONTask(API.getAccountNativeTest, parameters: params)
    }
}
