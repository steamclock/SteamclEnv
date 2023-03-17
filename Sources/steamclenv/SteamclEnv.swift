import ArgumentParser
import Foundation

enum SteamclEnvError: Error {
    case envNotFound

    var title: String {
        switch self {
        case .envNotFound:
            return ""
        }
    }

    var message: String {
        switch self {
        case .envNotFound:
            return ""
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
        func run() throws {
            print("Searching for environment files...")

            let fileManager = FileManager.default
            guard let fileData = fileManager.contents(atPath: "\(fileManager.currentDirectoryPath)/.env"),
                  let fileString = String(data: fileData, encoding: .utf8) else {
                throw SteamclEnvError.envNotFound
            }

            let lines = fileString.components(separatedBy: .newlines)

            let fileHeader = """
            enum Environment: String {

            """

            let fileFooter = """
            }
            """

            var fileContents = fileHeader

            for line in lines {
                let split = line.split(separator: "=")
                if split.count == 2 {
                    fileContents += "    case \(split[0])=\"\(split[1])\"\n"
                }
            }

            fileContents += fileFooter

            let fileOutputPath = "\(fileManager.currentDirectoryPath)/Environment.swift"
            try fileContents.write(toFile: fileOutputPath, atomically: true, encoding: .utf8)
        }
    }
}

enum Environment: String {
    case API_URL = "123123"
}
