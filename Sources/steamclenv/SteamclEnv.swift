import ArgumentParser

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
        func run() async {
            print("doot")
        }
    }
}
