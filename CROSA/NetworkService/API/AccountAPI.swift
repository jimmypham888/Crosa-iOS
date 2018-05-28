//
//  AccountAPI.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import Alamofire

class AccountAPI: AbstractAPI {
    static func login(username: String, password: String) -> AlamofireImmutableModelTask<Account>.T {
        let params: Parameters = [
            "username": username,
            "password": password
        ]
        return createModelTask(API.login, parameters: params)
    }
}

