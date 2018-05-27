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

let ACCESS_TOKEN: String = "eyJjdHkiOiJzdHJpbmdlZS1hcGk7dj0xIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJqdGkiOiJTS04yUGZBOFBKNnNucXJwMlRzVnV2ZHo0T2N4NDRiMzRPLTE1MjcxNDcxOTQiLCJpc3MiOiJTS04yUGZBOFBKNnNucXJwMlRzVnV2ZHo0T2N4NDRiMzRPIiwiZXhwIjoxNTI5NzM5MTk0LCJ1c2VySWQiOiJqaW1teSJ9.y6SQnGnBG0f7Z5p3aIMqkE_DGwRYxluSVz6vb1Smj4E"
