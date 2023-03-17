//
//  InstallCLI.swift
//  
//
//  Created by Brendan Lensink on 2023-03-17.
//

import Foundation
import PackagePlugin

//https://github.com/apollographql/apollo-ios/tree/main/Plugins/InstallCLI
@main
struct InstallCLIPluginCommand: CommandPlugin {

  func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
    let pathToCLI = try context.tool(named: "steamclev").path
    try createSymbolicLink(from: pathToCLI, to: context.package.directory)
  }

  func createSymbolicLink(from: PackagePlugin.Path, to: PackagePlugin.Path) throws {
    let task = Process()
    task.standardInput = nil
    task.environment = ProcessInfo.processInfo.environment
    task.arguments = ["-c", "ln -f -s '\(from.string)' '\(to.string)'"]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh")
    try task.run()
    task.waitUntilExit()
  }

}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension InstallCLIPluginCommand: XcodeCommandPlugin {

  /// 👇 This entry point is called when operating on an Xcode project.
  func performCommand(context: XcodePluginContext, arguments: [String]) throws {
    print("Installing SteamclEnv Plugin to Xcode project \(context.xcodeProject.displayName)")
    let pathToCLI = try context.tool(named: "steamclenv").path
    try createSymbolicLink(from: pathToCLI, to: context.xcodeProject.directory)
  }

}
#endif
