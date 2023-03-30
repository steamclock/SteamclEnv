import ArgumentParser
import Foundation

enum SteamclEnvError: LocalizedError {
    case envNotFound
    case invalidOutputDirectory
    case parseError

    var errorDescription: String {
        switch self {
        case .envNotFound:
            return "Couldn't locate your environment file."
        case .invalidOutputDirectory:
            return "Invalid output directory - does iut exist?"
        case .parseError:
            return "Couldn't parse environment file."
        }
    }
}


@main
struct SteamclEnv: ParsableCommand {
    static let configuration: CommandConfiguration = {
        return CommandConfiguration(
            commandName: "steamclenv",
            subcommands: [
                Generate.self
            ],
            defaultSubcommand: Generate.self
        )
    }()
}

extension SteamclEnv {
    struct Generate: ParsableCommand {
        @Flag(
          name: .long,
          help: "Toggle debug mode, which prints more information out to the console while running."
        )
        var debug: Bool = false

        @Flag(
          name: .shortAndLong,
          help: "Use .env.dev rather than .env."
        )
        var dev: Bool = false

        @Flag(
          name: .shortAndLong,
          help: "Obfuscates environment values. See the README for more information."
        )
        var obfuscate: Bool = false

        @Option(
          name: .shortAndLong,
          help: "Path to output your file should write to, relative to your current directory. You can include a full or partial path. File name will default to Environment.swift if not provided."
        )
        var outputPath: String?

        @Option(
          name: .shortAndLong,
          help: "Path to your environment file, relative to the current directory. This overrides --dev."
        )
        var path: String?

        func run() throws {
            Logger.shared.isDebug = debug
            Logger.shared.log("Searching for environment files...")

            let defaultFileName = "Environment.swift"
            let fileManager = FileManager.default
            var fileOutputPath = "\(fileManager.currentDirectoryPath)/\(defaultFileName)"

            if let outputPath = outputPath as? NSString {
                var directory = outputPath.pathExtension.isEmpty ?
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

            let environment = try EnvironmentGenerator(fileString, obfuscate: obfuscate)

            Logger.shared.log("Writing to \(fileOutputPath)")
            try environment.fileContents.write(toFile: fileOutputPath, atomically: true, encoding: .utf8)
        }
    }
}
