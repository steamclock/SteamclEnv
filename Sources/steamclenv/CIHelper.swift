//
//  CIHelper.swift
//  
//
//  Created by Brendan Lensink on 2023-03-28.
//

import ArgumentParser
import Foundation

enum CISource: String, ExpressibleByArgument {
    case bitrise
    case xcode

    var name: String {
        switch self {
        case .bitrise: return "Bitrise"
        case .xcode: return "Xcode Cloud"
        }
    }
}

extension SteamclEnv {
    struct CIHelper: ParsableCommand {
        @Argument(help: "The CI tool you want to generate a build script for.")
        var ciSource: CISource

        @Option(
          name: .shortAndLong,
          help: "Full path to your example environment file, including file name, if you don't want to use the default. Relative to the current directory."
        )
        var examplePath: String?

        @Option(
          name: .long,
          help: "A list of your environment variable keys, separated by commas. You can use this rather than passing in a .env.example file if desired."
        )
        var environmentKeys: String?

        func run() throws {
            let fileManager = FileManager.default
            Logger.shared.log("Generating build script for \(ciSource.name)")

            let path = examplePath ?? "\(fileManager.currentDirectoryPath)/.env.example"
            let exampleExists = fileManager.fileExists(atPath: path)

            guard exampleExists || environmentKeys != nil else {
                throw SteamclEnvError.missingKeys
            }

            var envKeys = [String]()

            if let keys = environmentKeys {
                envKeys = keys
                    .trimmingCharacters(in: .whitespaces)
                    .split(separator: ",")
                    .map { String($0) }
            } else if exampleExists {
                guard let fileData = fileManager.contents(atPath: path),
                      let fileString = String(data: fileData, encoding: .utf8) else {
                    throw SteamclEnvError.envNotFound
                }

                envKeys = fileString.components(separatedBy: .newlines)
            }

            guard !envKeys.isEmpty else { throw SteamclEnvError.missingKeys }

            print(generateXcodeScript(for: envKeys))
        }

        private func generateXcodeScript(for keys: [String]) -> String {
            let contents = keys.reduce(into: "") { result, line in
                let key = line.replacingOccurrences(of: "=", with: "")
                result += "\(key)=$\(key)\n"
            }

            return """
            #!/bin/sh

            echo "Writing .env file to current directory"

            printf "\(contents)" >> ../.env

            echo "Wrote .env file."

            exit 0
            """
        }
    }
}
