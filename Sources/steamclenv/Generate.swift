//
//  Generate.swift
//  
//
//  Created by Brendan Lensink on 2023-03-28.
//

import ArgumentParser
import Foundation

extension SteamclEnv {
    struct Generate: ParsableCommand {
        @Flag(
          name: .long,
          help: "Toggle debug mode, which prints more information out to the console while running."
        )
        var debug: Bool = false

        @Flag(
          name: .shortAndLong,
          help: "Use .env.dev rather than .env. This is superseded by --path if provided."
        )
        var dev: Bool = false

        @Option(
          name: .shortAndLong,
          help: "Path to output your file should write to, relative to your current directory. You can include a full or partial path. File name will default to Environment.swift if not provided."
        )
        var outputPath: String?

        @Option(
          name: .shortAndLong,
          help: "Path to your environment file if you don't want to use the default, relative to the current directory. This overrides --dev."
        )
        var path: String?

        @Option(
          name: .long,
          help: "Don't obfuscate your environment variables, instead include them as plain text."
        )
        var plainText: Bool = false

        func run() throws {
            let defaultFileName = "Environment.swift"
            let fileManager = FileManager.default
            var fileOutputPath = "\(fileManager.currentDirectoryPath)/\(defaultFileName)"

            if let outputPath = outputPath as? NSString {
                let directory = outputPath.pathExtension.isEmpty ?
                    outputPath.deletingPathExtension :
                    outputPath.deletingLastPathComponent

                let dirExists = fileManager.fileExists(atPath: directory)
                guard dirExists else { throw SteamclEnvError.invalidOutputDirectory }

                let outputExtension = outputPath.pathExtension
                if outputExtension.isEmpty {
                    let addSlash = outputPath.pathComponents.last == "/" ? "" : "/"
                    fileOutputPath = "\(outputPath)\(addSlash)Environment.swift"
                } else {
                    fileOutputPath = "\(outputPath)"
                }
            }

            Logger.shared.log("Searching for environment files...")

            let pathSuffix = path ?? (dev ? "/.env.dev" : ".env")
            let fullPath = "\(fileManager.currentDirectoryPath)/\(pathSuffix)"
            Logger.shared.log("Looking for file at \(fullPath)")

            guard let fileData = fileManager.contents(atPath: fullPath),
                  let fileString = String(data: fileData, encoding: .utf8) else {
                throw SteamclEnvError.envNotFound
            }

            let environment = try EnvironmentGenerator(fileString, obfuscate: !plainText)

            Logger.shared.log("Writing to \(fileOutputPath)")
            try environment.fileContents.write(toFile: fileOutputPath, atomically: true, encoding: .utf8)
        }
    }
}
