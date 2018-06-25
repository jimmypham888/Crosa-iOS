//
//  CRMtesterAPI.swift
//  CROSA
//
//  Created by Macbook on 6/11/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import Alamofire

class CRMTesterAPI: AbstractAPI {
    
    static func makeSchedule(phoneDefault: String, studentFullname:String, isVip:Int, tvtsName: String, dateInterview:String, hourID:Int, hourHalf:Int, teacherType:Int, note:String, studentId:Int, levelTester:Int) -> AlamofireJsonTask {
        let params: Parameters = [
        "phoneDefault": phoneDefault,
        "studentFullname": studentFullname,
        "tvtsName": tvtsName,
        "isVip": isVip,
        "dateInterview": dateInterview,
        "hourID": hourID,
        "hourHalf": hourHalf,
        "teacherType": teacherType,
        "note": note,
        "studentId": studentId,
        "levelTester": levelTester
        ]
        return createCRMJSONTask(API.makeSchedule, parameters: params)
}
    
    static func getInfo(phone: String) -> AlamofireJsonTask {
        let params: Parameters = [
            "phone": phone
        ]
        return createCRMJSONTask(API.getInfo, parameters: params)
    }
    
    static func getAutoSB(phoneDefault: String, studentFullname:String, isVip:Int, tvtsName: String, tuitionTypeId:Int, studentId:Int, typeSB:Int, vocabulary:Int, grammar:Int, write:Int, listen:Int) -> AlamofireJsonTask {
        let params: Parameters = [
            "phoneDefault": phoneDefault,
            "studentFullname": studentFullname,
            "tvtsName": tvtsName,
            "isVip": isVip,
            "typeSB": typeSB,
            "studentId": studentId,
            "tuitionTypeId": tuitionTypeId,
            "vocabulary": vocabulary,
            "grammar": grammar,
            "write": write,
            "listen": listen,
        ]
        return createCRMJSONTask(API.createSBLink, parameters: params)
    }
    
    static func cancelSchedule(phone: String) -> AlamofireJsonTask {
        let params: Parameters = [
            "phone": phone
        ]
        return createCRMJSONTask(API.cancelSchedule, parameters: params)
    }
    
    static func getMark(phone: String) -> AlamofireJsonTask {
        let params: Parameters = [
            "phone": phone
        ]
        return createCRMJSONTask(API.getMark, parameters: params)
    }
    
    
}
