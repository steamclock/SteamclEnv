//
//  Logger.swift
//
//  Created by Brendan Lensink on 2023-03-23.
//

import Foundation

struct Logger {
    static var shared = Logger()

    var isDebug = false

    private init() {}

    func log(_ message: String) {
        if isDebug { print(message) }
    }
}

