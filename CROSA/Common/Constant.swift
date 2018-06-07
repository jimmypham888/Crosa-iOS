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
}

let ACCESS_TOKEN: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6InN0cmluZ2VlLWFwaTt2PTEifQ.eyJqdGkiOiJTS04yUGZBOFBKNnNucXJwMlRzVnV2ZHo0T2N4NDRiMzRPLTE1MjgxNzM1NzQiLCJpc3MiOiJTS04yUGZBOFBKNnNucXJwMlRzVnV2ZHo0T2N4NDRiMzRPIiwiZXhwIjoxNTI4NTMzNTc0LCJ1c2VySWQiOiJqaW1teSIsInJlc3RfYXBpIjp0cnVlLCJpYXQiOjE1MjgxNzM1NzR9.D86iTEmPw-LfNVgL577cQFQCLg7gw2R6SU3QkmS36mE"
