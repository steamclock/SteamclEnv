import ArgumentParser
import Foundation

enum SteamclEnvError: LocalizedError {
    case envNotFound
    case parseError

    var errorDescription: String {
        switch self {
        case .envNotFound:
            return "Couldn't locate your environment file."
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
        @Option(
          name: .shortAndLong,
          help: "Path to your environment file, relative to the current directory. This overrides --dev."
        )
        var path: String?

        @Flag(
          name: .shortAndLong,
          help: "Use .env.dev rather than .env."
        )
        var dev: Bool = false

        @Flag(
          name: .long,
          help: "Toggle debug mode, which prints more information out to the console while running."
        )
        var debug: Bool = false

        func run() throws {
            Logger.shared.log("Searching for environment files...")

            let fileManager = FileManager.default
            let pathSuffix = path ?? (dev ? "/.env.dev" : ".env")
            let fullPath = "\(fileManager.currentDirectoryPath)/\(pathSuffix)"
            Logger.shared.log("Looking for file at \(fullPath)")

            guard let fileData = fileManager.contents(atPath: fullPath),
                  let fileString = String(data: fileData, encoding: .utf8) else {
                throw SteamclEnvError.envNotFound
            }

            let environment = try EnvironmentGenerator(fileString, debug: debug)

            let fileOutputPath = "\(fileManager.currentDirectoryPath)/Environment.swift"
            Logger.shared.log("Writing to \(fileOutputPath)")
            try environment.fileContents.write(toFile: fileOutputPath, atomically: true, encoding: .utf8)
        }
    }
}
