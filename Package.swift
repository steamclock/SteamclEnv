// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SteamclEnv",
    platforms: [
      .iOS(.v15),
      .macOS(.v12)
    ],
    products: [
        .executable(name: "steamclenv", targets: ["steamclenv"]),
        .plugin(name: "InstallCLI", targets: ["Install CLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "1.2.1")),
    ],
    targets: [
        .executableTarget(
            name: "steamclenv",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .plugin(
            name: "Install CLI",
            capability: .command(
                intent: .custom(
                    verb: "steamclenv-install",
                    description: "Installs the SteamclEnv Command line interface."
                ),
                permissions: [
                    .writeToPackageDirectory(reason: "Creates a symbolic link to the CLI executable in your project directory.")
                ]
            ),
            dependencies: [
                "steamclenv"
            ],
            path: "Plugins/InstallCLI"
        ),
    ]
)
