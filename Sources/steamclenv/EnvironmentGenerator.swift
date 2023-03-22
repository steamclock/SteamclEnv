//
//  EnvironmentGenerator.swift
//  
//
//  Created by Brendan Lensink on 2023-03-22.
//

import Foundation

struct EnvironmentGenerator {
    let fileHeader = """
    // @generated
    //  This file was automatically generated and should not be edited.
    enum Environment: String {

    """

    let fileFooter = """
    }
    """

    let entries: [String: String]
    let debug: Bool

    init(_ envContents: String, debug: Bool) throws {
        self.debug = debug

        let lines = envContents.components(separatedBy: .newlines)
        entries = lines.reduce(into: [String: String]()) { dict, line in
            let split = line.split(separator: "=")
            if split.count == 2 {
                let key = "\(split[0])"
                let value = "\(split[1])"
                if debug { print("Found key: \(key)") }
                dict[key] = value
            }
        }

        if entries.isEmpty { throw SteamclEnvError.parseError }
    }

    var fileContents: String {
        var contents = fileHeader

        entries.forEach { key, value in
            contents += "    case \(key)=\"\(value)\"\n"
        }

        contents += fileFooter

        return contents
    }
}
