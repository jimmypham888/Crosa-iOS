//
//  Constant.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import XCGLogger
import Foundation

let log: XCGLogger? = {
    #if DEBUG
    let log = XCGLogger.default
    log.setup(level: .debug,
              showFunctionName: false,
              showThreadName: true,
              showLevel: true,
              showFileNames: true,
              showLineNumbers: true,
              writeToFile: nil,
              fileLevel: .debug)
    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: " 🗯🗯🗯 ", postfix: " 🗯🗯🗯 ", to: .verbose)
    emojiLogFormatter.apply(prefix: " 🔹🔹🔹 ", postfix: " 🔹🔹🔹 ", to: .debug)
    emojiLogFormatter.apply(prefix: " ℹ️ℹ️ℹ️ ", postfix: " ℹ️ℹ️ℹ️ ", to: .info)
    emojiLogFormatter.apply(prefix: " ⚠️⚠️⚠️ ", postfix: " ⚠️⚠️⚠️ ", to: .warning)
    emojiLogFormatter.apply(prefix: " ‼️‼️‼️ ", postfix: " ‼️‼️‼️ ", to: .error)
    emojiLogFormatter.apply(prefix: " 💣💣💣 ", postfix: " 💣💣💣 ", to: .severe)
    log.formatters = [emojiLogFormatter]
    return log
    #else
    return nil
    #endif
}()

enum API {
    static let login = "login"
    static let listContact = "getContact"
    static let stockContact = "getStockInCts"
    static let pendingContact = "getPendingCts"
    static let contactDetail = ""
    static let getAllHistoryCall = "getAllHistoryCall"
    static let updateContact = "updateContact"
    static let updateHistoryCall = "updateHistoryCall"
    
    static let makeSchedule = "contact/add"
    static let cancelSchedule = "contact/cancel_schedule"
    static let createSBLink = "contact/receive_sbtopica"
    static let getInfo = "contact/info"
    static let getMark = "contact/mark"
    static let bookAcc = "bookAccount"
    static let getAccountNativeTest = "getAccountNativeTest"
}

let ACCESS_TOKEN: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6InN0cmluZ2VlLWFwaTt2PTEifQ.eyJqdGkiOiJTS04yUGZBOFBKNnNucXJwMlRzVnV2ZHo0T2N4NDRiMzRPLTE1Mjg1NDEyNTQiLCJpc3MiOiJTS04yUGZBOFBKNnNucXJwMlRzVnV2ZHo0T2N4NDRiMzRPIiwiZXhwIjoxNTMyMTQxMjU0LCJ1c2VySWQiOiJqaW1teSIsInJlc3RfYXBpIjp0cnVlLCJpYXQiOjE1Mjg1NDEyNTR9.SHCj_EVHrNFktlBlMai35JtX8IAxHfwKqw3l7HZ_6mo"
