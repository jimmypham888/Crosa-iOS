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
}
