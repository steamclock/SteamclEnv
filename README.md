# SteamclEnv
A library to make handling environment variables in Swift a little bit nicer.

## Installation

SteamclEnv uses a build script to generate your `Environment.swift` file at build time, so set up is a little more involved than your usual package...

1. Install SteamclEnv through the [Swift Package Manager](https://swift.org/package-manager/).
    a. In Xcode, click *File*, then *Swift Package Manager*, then *Add Package Dependency*
    b. In the search bar, enter: `git@github.com:steamclock/steamclenv.git`
    c. Select the `SteamclEnv` package and add it to your project
    
2. Setup and run code generation

SteamclEnv generates your `Environment.swift` file by parsing your `.env` file, so any time you make changes to your environment, you'll need to re-run SteamclEnv.

The easiest way to do this is with a build script, which requires you to install the SteamclEnv CLI. To make it easier to set up the CLI, you can run the bundled InstallCLI SPM plugin. This plugin builds the CLI and links the executable to your project.

To do this, right-click on your project in the Xcode file explorer, then select the Install CLI command. You'll need to grant the plugin 'write' access to you project directory for it to work.

3. Create your `.env` file(s)

By default, your `.env` file should live in the same directory as your `.xcodeproject` file. 

It's sometimes helpful to commit a `.env.example` file that contains all the keys found in your environment file, but not the values, to help folks who pull down your project know which keys they need to track down.

Don't forget to add them to your .gitignore as well.

4. Create your run script

In Xcode, select your target, then Build Phases, and add a new Run Script. Drag this Run Script above the 'Compile Sources' step, and enter your run script. It should look like:

```
./steamclenv generate
```

See [Usage](#usage) for a list of commands you can use to customize the generation.

5. Add your generated files to your target

Build your project and make sure your run script ran. By default your new `Environment.swift` file should be output to the root project directory. Add that file to your target, and you should be good to go! 

6. Make nice apps! 🚀

## Usage

SteamclEnv comes with a number of flags to customize code generation:

| Command | Short | Description |
| ------ | ------ | ---------- |
| --debug | n/a | Toggle debug mode, which prints more information out to the console while running. |
| --dev | -d | Use .env.dev rather than .env. This is superseded by --path if provided. |
| --obfuscate | -o | Obfuscates environment values. See the README for more information. |
| --path | -p | Path to your environment file, relative to the current directory. This overrides --dev. |

### Interfacing with Bitrise

< TODO >

### Obfuscation

Inspired by the folks at [NSHipster](https://nshipster.com/secrets/), this options obfuscates the values written out to your `Environment.swift` file, and provides some extra output to decode those values.

## License

SteamclEnv is available under the MIT license. See [LICENSE.md](https://github.com/steamclock/steamclenv/blob/main/LICENSE.md) for more info.
