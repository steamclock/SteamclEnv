//
//  EnvironmentGenerator.swift
//  
//
//  Created by Brendan Lensink on 2023-03-22.
//

import Foundation

struct EnvironmentGenerator {
    private let fileHeader = """
    // @generated
    // This file was automatically generated and should not be edited.
    // swiftlint:disable all

    enum Environment {

    """

    private let fileFooter = """
    // swiftlint:enable all    
    }
    """

    private let entries: [String: String]
    private let obfuscate: Bool

    init(_ envContents: String, obfuscate: Bool) throws {
        self.obfuscate = obfuscate

        let lines = envContents.components(separatedBy: .newlines)
        entries = try lines.reduce(into: [String: String]()) { dict, line in
            let split = line.split(separator: "=")

            guard split.count == 2 else { throw SteamclEnvError.parseError }

            let key = "\(split[0])"
            let value = "\(split[1])"

            Logger.shared.log("Found key: \(key)")

            dict[key] = value
        }

        if entries.isEmpty { throw SteamclEnvError.parseError }
    }

    var fileContents: String {
        var contents = fileHeader

        if obfuscate {
            Logger.shared.log("Generating obfuscated Environment file...")
            let obfuscator = ValueObfuscator()

            contents += obfuscator.saltOutput

            entries.forEach {
                contents += obfuscator.obfuscated(key: $0, value: $1)
            }
        } else {
            Logger.shared.log("Generating Environment file...")
            entries.forEach { key, value in
                contents += "    static let \(key) = \"\(value)\" \n"
            }
        }

        Logger.shared.log("Added \(entries.keys.count) entries to Environment 🚀")

        contents += fileFooter

        return contents
    }
}
