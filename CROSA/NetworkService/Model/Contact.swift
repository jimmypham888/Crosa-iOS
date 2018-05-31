//
//  Contact.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import ObjectMapper

class Contact: ImmutableMappable {
    
    let id: Int
    let name: String
    let phone: String
    let dateOfBirth: String
    let email: String
    let idUserManager: Int
    let idUserTvts: Int
    let idStatusCall: Int
    let status: Int
    let currentLevel: Int
    
    required init(map: Map) throws {
        id = try map.value("id")
        name = try map.value("name")
        phone = try map.value("phone")
        dateOfBirth = try map.value("date_of_birth")
        email = try map.value("email")
        idUserManager = try map.value("id_user_manager")
        idUserTvts = try map.value("id_user_tvts")
        idStatusCall = try map.value("id_status_call")
        status = try map.value("status")
        currentLevel = try map.value("current_level")
    }
    
    static func get(id: Int, success: @escaping ([Contact]) -> Void, failure: @escaping (String) -> Void) {
        ContactAPI.get(id: id)
            .success { success($0) }
            .failure { _ in }
    }
    
    func getRecord(success: @escaping ([HistoryCall]) -> Void,
                   failure: @escaping (String) -> Void) {
        ContactAPI.get(phoneNumber: phone)
            .success { success($0) }
            .failure { _ in }
    }
}
