//
//  Contact.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import ObjectMapper
import SwiftyJSON
class Contact: ImmutableMappable {
    
    let id: Int
    let name: String
    let phone: String
    let dateOfBirth: String
    let email: String
    let idUserManager: Int
    let idUserTvts: Int
//    let idStatusCall: Int
    let status: Int
    let currentLevel: Int?
    let dateLastCall: String?
    let studentId: String?
    let comment: String?
//    let dateLastCallDate: Date
    
    required init(map: Map) throws {
        id = try map.value("id")
        name = try map.value("name")
        phone = try map.value("phone")
        dateOfBirth = try map.value("date_of_birth")
        email = try map.value("email")
        idUserManager = try map.value("id_user_manager")
        idUserTvts = try map.value("id_user_tvts")
//        idStatusCall = try map.value("id_status_call")
        status = try map.value("status")
        currentLevel = try? map.value("current_level")
        dateLastCall = try? map.value("start_time")
        studentId = try? map.value("studentId")
        comment = try? map.value("comment")
//       print("level \(currentLevel)")
    }
    
    static func get(id: Int, success: @escaping ([Contact]) -> Void, failure: @escaping (String) -> Void) {
        ContactAPI.get(id: id)
            .success { success($0) }
            .failure { _ in }
    }
    
    static func getPending(id: String, call_schedule: String, success: @escaping ([Contact]) -> Void, failure: @escaping (String) -> Void) {
        ContactAPI.getPending(id: id, call_schedule: call_schedule)
            .success { success($0) }
            .failure { _ in }
    }
    
    static func getStock(id: String, success: @escaping ([Contact]) -> Void, failure: @escaping (String) -> Void) {
        ContactAPI.getStock(id: id)
            .success { success($0) }
            .failure { _ in }
    }
    
    func getRecord(success: @escaping ([HistoryCall]) -> Void,
                   failure: @escaping (String) -> Void) {
        ContactAPI.get(phoneNumber: phone)
            .success { success($0) }
            .failure { _ in }
    }
    
    func updateContact(id: String, name: String, email: String, phone: String,
                       success: @escaping (JSON) -> Void,
                       failure: @escaping (String) -> Void) {
        ContactAPI.update(id: id, name: name, email: email, phone: phone)
            .success { json in success(json) }
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
    
    func updateCall(id: String, name: String, email: String, level:String, call_id:String, callBackTime: String, comment: String, phone:String,
                       success: @escaping (JSON) -> Void,
                       failure: @escaping (String) -> Void) {
        ContactAPI.updateFull(id: id, name: name, email: email, level: level, call_id: call_id, callBackTime: callBackTime, comment: comment, phone: phone)
            .success { json in success(json) }
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
    
    func updateCallNoCallId(id: String, name: String, email: String, level:String, callBackTime: String, comment: String, phone:String,
                    success: @escaping (JSON) -> Void,
                    failure: @escaping (String) -> Void) {
        ContactAPI.updateFullNoCallID(id: id, name: name, email: email, level: level, callBackTime: callBackTime, comment: comment, phone: phone)
            .success { json in success(json) }
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
    
    func makeSchedule(phoneDefault: String, studentFullname:String, isVip:Int, tvtsName: String, dateInterview:String, hourID:Int, hourHalf:Int, teacherType:Int, note:String, studentId:Int, levelTester:Int,
                      success: @escaping (JSON) -> Void,
                      failure: @escaping (String) -> Void) {
        CRMTesterAPI.makeSchedule(phoneDefault: phoneDefault, studentFullname: studentFullname, isVip: isVip, tvtsName: tvtsName, dateInterview: dateInterview, hourID: hourID, hourHalf: hourHalf, teacherType: teacherType, note: note, studentId: studentId, levelTester: levelTester)
            .success { json in success(json) }
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
    
     func getInfoCRM(phone: String,
                     success: @escaping (JSON) -> Void,
                     failure: @escaping (String) -> Void) {
        CRMTesterAPI.getInfo(phone: phone)
            .success { json in success(json) }
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
    
    func getMarkCRM(phone: String,
                    success: @escaping (JSON) -> Void,
                    failure: @escaping (String) -> Void) {
        CRMTesterAPI.getMark(phone: phone)
            .success { json in success(json) }
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
    
    func cancelSchedule(phone: String,
                    success: @escaping (JSON) -> Void,
                    failure: @escaping (String) -> Void) {
        CRMTesterAPI.cancelSchedule(phone: phone)
            .success { json in success(json) }
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
    
    func getAutoSB(phoneDefault: String, studentFullname:String, isVip:Int, tvtsName: String, tuitionTypeId:Int, studentId:Int, typeSB:Int, vocabulary:Int, grammar:Int, write:Int, listen:Int,
                      success: @escaping (JSON) -> Void,
                      failure: @escaping (String) -> Void) {
        CRMTesterAPI.getAutoSB(phoneDefault: phoneDefault, studentFullname: studentFullname, isVip: isVip, tvtsName: tvtsName, tuitionTypeId: tuitionTypeId, studentId: studentId, typeSB: typeSB, vocabulary: vocabulary, grammar: grammar, write: write, listen: listen)
            .success { json in success(json) }
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
    
    func bookAccount(id_contact: String,
                    success: @escaping (JSON) -> Void,
                    failure: @escaping (String) -> Void) {
        CRMNativeAPI.bookAccount(id_contact: id_contact)
            .success { json in success(json) }
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
    
    func getNative(id_contact: String,
                     success: @escaping (JSON) -> Void,
                     failure: @escaping (String) -> Void) {
        CRMNativeAPI.getAccountNativeTest(id_contact: id_contact)
            .success { json in success(json) }
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
