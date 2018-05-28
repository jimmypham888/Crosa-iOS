//
//  Account.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

//class Account {
//    static let `default` = Account()
//    static let accountDefaultsKey = "crosa_account"
//
//}

class AccountAuth {
    static let `default` = AccountAuth()
    static let accountDefaultsKey = "crosa_account"
    
    private let keyName = "name"
    private let keyUsername = "username"
    private let keyid = "id"
    private let keyEmail = "email"
    
    private(set) var name: String
    private(set) var username: String
    private(set) var id: Int
    private(set) var email: String
    
    var isLogin: Bool {
        return id != 0
    }
    
    private init() {
        let defaults = UserDefaults.standard
        if let jsonString = defaults.string(forKey: AccountAuth.accountDefaultsKey),
            let jsonData = jsonString.data(using: .utf8),
            let json = try? JSON(data: jsonData) {
            name = json[keyName].stringValue
            username = json[keyUsername].stringValue
            id = json[keyid].intValue
            email = json[keyEmail].stringValue
        } else {
            name = ""
            username = ""
            id = 0
            email = ""
        }
    }
    
    private func save() {
        let defaults = UserDefaults.standard
        let jsonData = try! JSONSerialization.data(withJSONObject: asJson(), options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)! as String
        defaults.set(jsonString, forKey: AccountAuth.accountDefaultsKey)
        defaults.synchronize()
    }
    
    func asJson() -> [String: AnyObject] {
        var hash = [String: AnyObject]()
        if name != "" { hash[keyName] = name as AnyObject }
        if username != "" { hash[keyUsername] = username as AnyObject }
        if id != 0 { hash[keyid] = id as AnyObject }
        if email != "" { hash[keyEmail] = email as AnyObject}
        hash[keyEmail] = email as AnyObject
        
        return hash
    }
    
    func updateAccount(account: Account) {
        name = account.name
        username = account.userName
        id = account.id
        email = account.email
        save()
    }
    
    func logout() {
        name = ""
        username = ""
        email = ""
        id = 0
        
        save()
    }
}

class Account: ImmutableMappable {
    
    let name: String
    let userName: String
    let id: Int
    let email: String
    let idRole: Int
    let statitionDefault: String
    
    required init(map: Map) throws {
        name = try map.value("name")
        userName = try map.value("username")
        id = try map.value("id")
        email = try map.value("email")
        idRole = try map.value("id_role")
        statitionDefault = try map.value("statition_default")
    }
    
    static func login(username: String,
                      password: String,
                      success: @escaping (Account) -> Void,
                      failure: @escaping (String) -> Void) {
        AccountAPI.login(username: username, password: password)
            .success { success($0) }
            .failure { (error, _) in
                guard let error = error else {
                    failure("")
                    return
                }
                
                if let jsonError = try? JSON(data: error.body) {
                    failure(jsonError["message"].stringValue)
                }
        }
    }
}
