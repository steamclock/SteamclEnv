import ArgumentParser
import Foundation

enum SteamclEnvError: LocalizedError {
    case envNotFound
    case invalidOutputDirectory
    case parseError
    case missingKeys

    var errorDescription: String {
        switch self {
        case .envNotFound:
            return "Couldn't locate your environment file."
        case .invalidOutputDirectory:
            return "Invalid output directory - does iut exist?"
        case .parseError:
            return "Couldn't parse environment file."
        case .missingKeys:
            return "No API keys provided, check your provided path"
        }
    }
}


@main
struct SteamclEnv: ParsableCommand {
    static let configuration: CommandConfiguration = {
        return CommandConfiguration(
            commandName: "steamclenv",
            subcommands: [
                CIHelper.self,
                Generate.self
            ],
            defaultSubcommand: Generate.self
        )
    }()
}
