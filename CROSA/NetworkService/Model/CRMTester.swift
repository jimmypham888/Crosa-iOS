//
//  File.swift
//  CROSA
//
//  Created by Macbook on 6/11/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import ObjectMapper
import SwiftyJSON
class CRMTester: ImmutableMappable{
    let tvtsName: String
    let studentId: String
    let studentFullname: String
    let phoneDefault: String
    let phone2: String
    let phone3: String
    let isVip: String
    let teacherType: String
    let teacherTypeDes: String
    let dateInterview: String
    let hourID: String
    let hourHalf: String
    let interviewStatus: String
    let interviewStatusDes: String
    let contactStatus: String
    let dateInterviewNew: String
    let hourIdOldNew: String
    let hourHalfOldNew: String
    let teacherTypeNew: String
    let teacherTypeNewDes: String
    let interviewStatusNew: String
    let interviewStatusNewDes: String
    let dateInterviewOld: String
    let hourIdOld: String
    let hourHalfOld: String
    let teacherTypeOld: String
    let teacherTypeOldDes: String
    let interviewStatusOld: String
    let interviewStatusOldDes: String
    let timeChange: String
    let note: String
    
    
    required init(map: Map) throws {
        tvtsName = try map.value("tvtsName")
        studentId = try map.value("studentId")
        studentFullname = try map.value("studentFullname")
        phoneDefault = try map.value("phoneDefault")
        phone2 = try map.value("phone2")
        phone3 = try map.value("phone3")
        isVip = try map.value("isVip")
        teacherType = try map.value("teacherType")
        teacherTypeDes = try map.value("teacherTypeDes")
        dateInterview = try map.value("dateInterview")
        hourID = try map.value("hourID")
        hourHalf = try map.value("hourHalf")
        interviewStatus = try map.value("interviewStatus")
        interviewStatusDes = try map.value("interviewStatusDes")
        contactStatus = try map.value("contactStatus")
        dateInterviewNew = try map.value("dateInterviewNew")
        hourIdOldNew = try map.value("hourIdOldNew")
        hourHalfOldNew = try map.value("hourHalfOldNew")
        teacherTypeNew = try map.value("teacherTypeNew")
        teacherTypeNewDes = try map.value("teacherTypeNewDes")
        interviewStatusNew = try map.value("interviewStatusNew")
        interviewStatusNewDes = try map.value("interviewStatusNewDes")
        dateInterviewOld = try map.value("dateInterviewOld")
        hourIdOld = try map.value("hourIdOld")
        hourHalfOld = try map.value("hourHalfOld")
        teacherTypeOld = try map.value("teacherTypeOld")
        teacherTypeOldDes = try map.value("teacherTypeOldDes")
        interviewStatusOld = try map.value("interviewStatusOld")
        interviewStatusOldDes = try map.value("interviewStatusOldDes")
        timeChange = try map.value("timeChange")
        note = try map.value("note")
    }
    
    
}
