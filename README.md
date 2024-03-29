# SteamclEnv
A library to make handling environment variables in Swift a little bit nicer.

- [Usage](#usage)
    - [Using `generate`](#using-generate)
- [Interfacing with CI](#interfacing-with-ci)
    - [Bitrise](#bitrise)
    - [Xcode Cloud](#xcode-cloud)
- [Installation](#installation)
- [License](#license)

# Usage

SteamclEnv contains two main commands: `generate` to generate your `Environment.swift` file via a build script when developing locally, and `ci-helper` to reproduce the same behaviour with various CI tools see [interfacing with CI](#interfacing-with-ci) below for more info on the latter.

## Using `generate`

After [installation](#installation), you should just be able to call `steamclenv generate` and have things ✨just work✨, but we provide some additional options if desired:

| Command | Short | Description |
| ------ | ------ | ---------- |
| --debug | n/a | Toggle debug mode, which prints more information out to the console while running the script. |
| --dev | -d | Use `.env.dev` rather than `.env`. This is superseded by --path if provided. |
| --output-path | -o | Path to output your file should write to, relative to your current directory. You can include a full or partial path. File name will default to Environment.swift if not provided. |
| --path | -p | Path to your environment file, relative to the current directory. This overrides --dev. |
| --plain-text | n/a | Turns off variable obfuscation. See [obfuscation](#obfuscation) for more information. |


# Interfacing with CI

Included with SteamclEnv is a command to help generate run scripts for generating your environment variables in CI. Called `ci-helper`, we currently provide utilities to generate run scripts for Bitrise, and Xcode Cloud. 

The followinga additional commands are available:

| Command | Short | Description |
| --example-path | -e | Full path to your example environment file, including file name, if you don't want to use the default. Relative to the current directory. |
| --environment-keys | n/a | A list of your environment variable keys, separated by commas. You can use this rather than passing in a .env.example file if desired. | 
| --output-path | -o | Full path you'd like to output your finished environment file to, including filename, relative to the current directory. |

## Bitrise

1. In the Bitrise workflow editor, add your environment variables to the project, being sure to match the variable keys that are in your `.env` file.

2. Use the `ci-helper bitrise` command to generate your script, providing your environment keys using a `.env.example` file or passing them in with the `environmentKeys` option. Make sure you provide an `--output-path` if using a non-standard location for `Environment.swift` as well.

3. Add a new Script step to your workflow between your `Git Clone Repository` and `xcodebuild` steps, and copy the contents of the outputted `bitrise.sh` into that script.

4. Trigger a new build and your `Environment.swift` file should be generated as the script runs.

## Xcode Cloud

1. Add your environment variables to your workflow in App Store Connect, being sure to match the variable keys that are in your `.env` file.

2. Use the `ci-helper xcode` command to generate your script, providing your environment keys using a `.env.example` file or passing them in with the `environmentKeys` option. Make sure you provide an `--output-path` if using a non-standard location for `Environment.swift` as well.

3. Copy the resulting `ci_pre_xcodebuild.sh` file into your `ci_scripts` folder. Note this folder should be at the root directory of your project to ensure it is run. You may need to use `chmod +x ./ci_pre_xcodebuild.sh` to ensure your script runs. See the [Apple documentation](https://developer.apple.com/documentation/xcode/writing-custom-build-scripts) for more info.

4. Commit and push your changes with the new run script. Start a new build and your `Environment.swift` file should be generated as the script runs.

### Obfuscation

Inspired by the folks at [NSHipster](https://nshipster.com/secrets/), by default the values generated in your `Environment.swift` file are obfuscated. You can pass in the `--plain-text` command to turn this off if desired. While this isn't a perfect solution by any means, we feel it provides an extra small measure of obscurity that's worth including.

# Installation

SteamclEnv uses a build script to generate your `Environment.swift` file at build time, so set up is a little more involved than your usual package...

### 1. Install SteamclEnv through the [Swift Package Manager](https://swift.org/package-manager/).
    a. In Xcode, click *File*, then *Swift Package Manager*, then *Add Package Dependency*
    b. In the search bar, enter: `git@github.com:steamclock/steamclenv.git`
    c. Select the `SteamclEnv` package and add it to your project
    
### 2. Create your `.env` file(s)

By default, your `.env` file should live in the same directory as your `.xcodeproject` file. Your environment variables should use an `=` sign, with no leading or trailing spaces, to seperate keys and values and include one pair per line. Like so:

```
KEY=VALUE
ANOTHER_KEY=ANOTHER_VALUE
```

You can see an example of each of these files in the [example project](https://github.com/steamclock/SteamclEnv/tree/main/SteamclEnv-Example).

It's sometimes helpful to commit a `.env.example` file that contains all the keys found in your environment file, but not the values, to help folks who pull down your project know which keys they need to track down. Doing so will make setting up your CI scripts easier as well.

Don't forget to add your `.env` files (and `Environment.swift`) to your `.gitignore` as well.
    
### 3. Setup and run code generation

SteamclEnv generates your `Environment.swift` file by parsing your `.env` file, so any time you make changes to your environment, you'll want to re-run SteamclEnv.

The easiest way to do this is with a build script, which requires you to install the SteamclEnv CLI. To make it easier to set up the CLI, you can run the bundled InstallCLI SPM plugin. This plugin builds the CLI and links the executable to your project.

To do this, right-click on your project in the Xcode file explorer, then select the Install CLI command. You'll need to grant the plugin 'write' access to your project directory for it to work.

### 4. Create your run script

In Xcode, select your target, then Build Phases, and add a new Run Script. Drag this Run Script above the 'Compile Sources' step, and enter your run script. It should look like:

```
if which ./steamclenv; then 
    ./steamclenv generate
else
    echo "Warning: SteamclEnv was expected to run but is not installed."
fi
```

See [Usage](#usage) for a list of commands you can use to customize the generation.

### 5. Add your generated files to your target

Build your project and make sure your run script ran. By default your new `Environment.swift` file should be output to the root project directory. Add that file to your target, and you should be good to go! 

### 6. Make nice apps! 🚀

# License

SteamclEnv is available under the MIT license. See [LICENSE.md](https://github.com/steamclock/steamclenv/blob/main/LICENSE.md) for more info.
