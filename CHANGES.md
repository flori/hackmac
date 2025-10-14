# Changes

## 2025-10-14 v1.8.5

- Improved version parsing in `github_source.rb` by adding regex validation
  `/\A\d+\.\d+\.\d+\z/` before creating `Version` objects
- Enhanced version parsing in `kext.rb` with regex validation
  `/\A\d+\.\d+\.\d+\z/` before parsing `CFBundleShortVersionString()` as a
  version
- Both changes ensure only valid semantic version strings are processed by the
  `Version` class, preventing errors from malformed version identifiers

## 2025-09-20 v1.8.4

- Added a new section titled "Documentation" to the README with a link to the
  API documentation hosted at GitHub.io
- Renamed `.context/code_comment.rb` to `.contexts/code_comment.rb` and updated
  the directory structure for code comment context files while maintaining all
  existing functionality
- Added a new GitHub Actions workflow file `.github/workflows/static.yml` to
  deploy static content to GitHub Pages
- Updated the `Rakefile` to include the `.github` directory in the
  `package_ignore` list and configured the workflow to run on push to the
  master branch and manual dispatch
- Set up permissions for deployment to GitHub Pages and installed the
  `gem_hadar` gem to generate documentation using `rake doc`
- Added `.yardoc` and `doc` directories to `.gitignore` and updated the
  `Rakefile` to ignore these directories while removing `.byebug_history` from
  both files
- Fixed markdown escaping in documentation comments, specifically updating the
  `@param` documentation tag in `asset_tools.rb` to yield instead of block and
  escaping `\@format_value` and `\@plist` references in `graph.rb` and
  `plist.rb` respectively

## 2025-09-19 v1.8.3

- Enhanced README with improved formatting and detailed tool descriptions
- Added better error handling in `kexts` command with `Errno::ENOENT` rescue
- Updated `gem_hadar` development dependency from version **1.20** to **2.6**
- Included `s.licenses = ["MIT".freeze]` in `hackmac.gemspec` and added `MIT`
  license to gem specification
- Added `.gitignore` and `.contexts` to `package_ignore` list in `Rakefile`
- Updated print call syntax to use explicit parentheses
- Added `.context/code_comment.rb` to `hackmac.gemspec` and configured it for
  code comment context

## 2025-07-21 v1.8.2

- Added a new `usage` method to provide help information when invalid arguments
  are encountered.
- Improved argument parsing for the USB device name parameter.

## 2025-02-18 v1.8.1

- Updated `Hackmac::Kext_upgrader` to handle version comparison errors by
  adding error handling for unconventional versions.
- Improved the `git pull` command in the `usb` script to use the source branch
  and set upstream correctly.
- Unfroze empty strings in `Hackmac::Graph::Display` to allow modifications if
  necessary.
- Updated the README.md file to reflect the new HackMac project description and
  correct the gem URL.
- Updated the `hackmac.gemspec` file with newer RubyGems versions, including:
  - Updated `s.date` from **2024-12-24** to **2025-02-18**
  - Updated `s.rubygems_version` from **3.6.1** to **3.6.2**
  - Bumped the `gem_hadar` development dependency to ~> **1.19**
- Added error handling for version comparison in `Hackmac::Kext_upgrader` to
  allow forcing updates for unconventional versions.

## 2024-07-24 v1.8.0

- Upgraded the `term-ansicolor` dependency from version **1.3** to **1.10**
- Updated the `gem_hadar` development dependency to version **1.16.0**
- Modified the `bin/gfxmon` script to enable true coloring when supported by
  the terminal

## 2023-11-21 v1.7.2

- Added the `--downloadassets` flag to the `sudo #{cim.inspect}` command in the
  `usb` script, enabling asset download during installation.

## 2023-11-19 v1.7.1

- Removed the `infobar` gem dependency from the project.
- Updated the version number to **1.7.1** in multiple files including
  `VERSION`, `hackmac.gemspec`, and `lib/hackmac/version.rb`.
- Modified the `x` method in `lib/hackmac/utils.rb` to remove reliance on
  `infobar` for displaying progress and status messages, instead using direct
  `puts` calls.
- Updated the `usb` script in `bin/usb` to simplify command execution by
  removing the `busy` parameter from the `x` method calls.

## 2023-10-09 v1.7.0

- Added the `infobar` gem with version constraint `>=0.7.1` to display a busy
  indicator during shell command execution.
- Modified the `x` method in `lib/hackmac/utils.rb` to accept an optional
  `busy` parameter, enabling the display of a progress indicator for
  long-running commands.
- Updated the version number from **1.6.1** to **1.7.0** across all relevant
  files.

## 2023-09-04 v1.6.1

- Improved color selection algorithm by using fewer bits in the
  `Hackmac::Graph` class.
- Added executable bit to the `bin/efi` script.

## 2023-05-29 v1.6.0

- Added a new method `derive_color_from_string(string)` in the `Hackmac::Graph`
  class to generate colors based on string input.
- Modified the `list(ps)` function to sort metrics by name and display them
  with colored text using ANSI color codes.
- Updated the documentation and added a LICENSE file.
- Added a screenshot of the gfxmon tool to the project's img directory.

## 2023-05-28 v1.5.1

- **Added** `Hackmac::IOReg` class to handle fetching and parsing of IORegistry
  data using `plist` output instead of parsing the raw output of `ioreg`.
- **Updated** `gfxmon` script to use `Hackmac::IOReg.new(key:
  'PerformanceStatistics').as_hash` for fetching performance statistics,
  replacing the previous method that parsed `ioreg` output.
- **Added** dependency on `hashie` gem to support deep finding in hashes within
  the `IOReg` class.
- **Updated** version number from **1.5.0** to **1.5.1** across all relevant
  files.

## 2023-05-28 v1.5.0

- Optimized performance by modifying the `Hackmac::Graph` class:
  - Changed variable initialization from `i = 0` to `@counter = -1`
  - Added `@start = Time.now` for timing purposes
  - Modified sleep duration calculation in `sleep_now` method
  - Improved display diff handling with additional debug logging when
    `ENV['DEBUG_BYTESIZE']` is set
- Updated ANSI color application logic in `Hackmac::Graph::Display` class to
  use string concatenation instead of nested blocks

## 2023-05-28 v1.4.2

- Improved variable naming in the config file
- Updated version number to **1.4.2**
- Added color output for config loading messages using `Term::ANSIColor`
- Modified config path environment variable from `CONFIG_PATH` to
  `HACKMAC_CONFIG`
- Added exit status handling for failed commands in utils

## 2023-05-28 v1.4.1

- Improved command output formatting in the `x` method of `Hackmac::Utils`
  - Added emoji indicators for command success (`✅`) and failure (`⚠️`)
  - Changed command prompt color based on whether `sudo` is used
  - Simplified verbose output handling

## 2023-05-28 v1.4.0

- Improved performance of graph display to reduce flickering.
- Modified the `-g` option to `-m` in `gfxmon` for specifying performance
  metrics.
- Added a new method `choose_metric` that now uses `$opts[?m]` instead of
  `$opts[?g]`.
- Introduced a new module `Hackmac::Graph::Formatters` to handle different
  value formatting (e.g., bytes, hertz, celsius, percent).
- Refactored the graph implementation to use a new `Hackmac::Graph::Display`
  class for better management of terminal output.
- Added support for mutex synchronization in graph updates to prevent display
  issues during resizing or concurrent operations.
- Enhanced error handling and argument validation (e.g., ensuring sleep
  duration is non-negative).

## 2023-05-27 v1.3.0

- Refactored the graph implementation from a hack to a proper `Hackmac::Graph`
  class.
- Added new methods and functionality:
  - `derive_formatter` method for determining value formatting based on metric
    type.
  - Various formatting methods: `as_bytes`, `as_hertz`, `as_celsius`,
    `as_percent`, and `as_default`.
  - Improved graph rendering with better color handling, data processing, and
    window resizing support.
- Updated the gemspec to include the new `graph.rb` file.
- Removed the old `format_bytes` method in favor of the new class-based
  approach.

## 2023-05-15 v1.2.1

- Added an additional check for the existence of `createinstallmedia` at
  `#{$config.usb.os}/Contents/Resources/createinstallmedia`.
- Updated version numbers to **1.2.1** in `VERSION`, `hackmac.gemspec`, and
  `lib/hackmac/version.rb`.
- Modified the USB installation script to verify the presence of the macOS
  installer before proceeding.
- Added a step to set the upstream branch for Git operations during EFI setup.

## 2023-04-23 v1.2.0

- Added a check to verify if the installer exists before proceeding with
  installation. If the installer is not found, an error message is displayed.
- Modified the EFI setup process by adding `git branch
  --set-upstream-to=origin/master` to set the upstream branch for the local Git
  repository.

Version numbers updated:
- **1.2.0**

## 2023-02-18 v1.1.3

- Extracted the sample/default configuration into a new file `hackmac.yml` to
  improve maintainability and organization.
- Simplified the USB mounting process by dynamically determining mountpoints
  based on configuration values, reducing manual checks for existing mounts.

## 2022-10-06 v1.1.2

- Captured stderr for commands by modifying the `x` method in
  `lib/hackmac/utils.rb` to include `2>&1`.
- Updated development dependency from `byebug` to `debug` in `Rakefile` and
  `hackmac.gemspec`.
- Added help information about setting `CONFIG_PATH` in `bin/efi`.

## 2022-07-12 v1.1.1

- Updated the version number to **1.1.1** in `VERSION`, `hackmac.gemspec`, and
  `lib/hackmac/version.rb`.
- Modified the `usb` script to use `File.basename(dev)` when processing the
  device argument.

## 2022-05-26 v1.1.0

- Added a new command `oc_validate` to the `efi` tool for validating OpenCore's
  config.plist.
- Added a new class `OCValidator` in `lib/hackmac/oc_validator.rb` to handle
  OpenCore validation logic.
- Updated the gem version from **1.0.5** to **1.1.0**.
- Updated the list of files and documentation in the gemspec to include the new
  validator class.

## 2022-05-26 v1.0.5

- Added the root path `/` to the USB creation process.
- Updated version number from **1.0.4** to **1.0.5** in multiple files
  including `VERSION`, `hackmac.gemspec`, and `lib/hackmac/version.rb`.

## 2022-05-26 v1.0.4

- Added `sudo chown $USER .` to change ownership of the EFI directory in the
  `usb` script.
- Reordered commands in the `usb` script, moving the creation of the
  installation media to before mounting the EFI partition.

## 2022-05-26 v1.0.3

- Changed the order of commands in the `usb` script.
- Updated version numbers to **1.0.3** across various files including
  `VERSION`, `hackmac.gemspec`, and `lib/hackmac/version.rb`.
- Removed redundant execution of the command `sudo
  "#{$config.usb.os}/Contents/Resources/createinstallmedia" --volume
  #{mountpoint.inspect} --nointeraction` in the `usb` script.

## 2022-05-26 v1.0.2

- Updated the version number from **1.0.1** to **1.0.2** in multiple files.
- Modified the `File.secure_write` method call in `lib/hackmac/config.rb` to
  use `path.to_s` instead of `path`.

## 2022-05-26 v1.0.1

- Upgraded the default configuration with several changes:
  - Updated `efi.source` to `'storage.gate.ping.de:/git/EFI-hacmaxi.git'`
  - Changed `usb.os` to `/Applications/Install macOS Monterey.app`
  - Modified `oc.efi_path` to `'EFI'`
  - Added new configuration under `oc.files` including:
    - `'BOOT/BOOTx64.efi'`
    - `'OC/OpenCore.efi'`
    - `'OC/Drivers/OpenHfsPlus.efi'`
    - `'OC/Drivers/OpenRuntime.efi'`
    - `'OC/Tools/OpenShell.efi'`
  - Updated `kext.efi_path` to `'EFI/OC/Kexts'`
  - Added new kext source for `LucyRTL8125Ethernet` with github repository
    `'Mieze/LucyRTL8125Ethernet'`

## 2022-05-26 v1.0.0

- Added support for OpenCore with new commands `oc`, `oc_remote`, and
  `oc_upgrade`  
  - Commands added to `bin/efi` script  
  - New classes `Hackmac::OC` and `Hackmac::OCUpgrader` implemented  
- Removed Clover-related functionality  
- Version bumped from **0.8.3** to **1.0.0**  
- Refactored asset download logic with new module `Hackmac::AssetTools`  
  - Moved decompression logic to shared module  
- Renamed classes for clarity:  
  - `KextSource` → `GithubSource`  
  - `KextDownload` → `URLDownload`  
- Removed support for boot device management  
  - Removed `list` command from `bin/efi`  
  - Removed `boot_dev` method and related functionality  
- Updated dependencies in `hackmac.gemspec`  
  - Updated `gem_hadar` dependency to **~> 1.12.0**  
  - Updated RubyGems version to **3.3.13**

## 2021-03-05 v0.8.3

- Updated the `BrcmPatchRAM` configuration to use Acidanthera's release instead
  of RehabMan's.

## 2020-12-13 v0.8.2

- Added `require 'pathname'` to the list of required libraries in `hackmac.rb`.
- Updated version number from **0.8.1** to **0.8.2** across multiple files.
- Modified the `kext` and `kext_upgrade` commands in `efi` script to use
  expanded paths by converting the input path using
  `Pathname.new(path).expand_path.to_s`.

## 2020-08-22 v0.8.1

- Updated the regular expression in `boot_dev` method to handle both `\r` and
  `\n` line endings.
- Bumped version from **0.8.0** to **0.8.1** across all relevant files.

## 2020-08-17 v0.8.0

- Added support for aliases in the list of EFI partitions, allowing users to
  map device names to their corresponding identifiers.
- Updated the configuration file with new default values and added
  documentation for clarity.
- Modified the `efi` command to display alias information when listing EFI
  partitions.

## 2020-08-14 v0.7.0

- Moved configuration file from `~/config/hackmac.yml` to
  `~/.config/hackmac/hackmac.yml`.
- Added support for downloading kexts that are not released.
- Updated the decompression functionality to handle both `.zip` and `.tar.gz`
  files.
- Modified the `KextSource` class to allow decompressing of `.tar.gz` files in
  addition to `.zip`.
- Created a new `KextDownload` class to handle downloading kexts from specified
  URLs.

## 2020-05-15 v0.6.2

- Added `--cached` option to the `git_args` method in the `efi` script,
  enhancing diff functionality.

## 2020-05-13 v0.6.1

- Added `git add -A` before committing in the `commit` command of the `efi`
  script to ensure all changes are staged.
- Updated version numbers from **0.6.0** to **0.6.1** across multiple files
  including `VERSION`, `hackmac.gemspec`, and `lib/hackmac/version.rb`.
- Reformatted code in several parts of the `efi` script for better readability,
  such as splitting long lines into multiple lines and improving indentation.
- Modified the `diff` command in the `efi` script to include all changes by
  using `git add -A` before generating the diff.

## 2020-05-05 v0.6.0

- Added support for installing debug kexts by introducing a `force` parameter
  in the `kext_upgrade` command.
- Updated the version number from **0.5.0** to **0.6.0** across all relevant
  files.
- Modified the `KextSource` class to include a `suffix` parameter, allowing for
  differentiation between debug and release builds.
- Enhanced the `efi` script with new commands: `diff` and `commit`, which
  enable diffing changes and committing them using git on the EFI partition.

## 2020-03-05 v0.5.0

- Added support for EFI Git repository operations
  - Implemented `git_args` method to handle command line arguments
  - Added new commands: 
    - `diff`: Runs `git diff` on mounted EFI volume with default args `--color
      --stat`
    - `commit`: Commits changes and pushes to remote with default arg `-v`
- Updated version number from **0.4.2** to **0.5.0**
- Added `Shellwords` require in utils module
- Updated copyright date to 2020-03-05

## 2020-02-13 v0.4.2

- **0.4.2**: Fixed a crash that could occur when no plugins were available by
  modifying the condition in `Hackmac::KextUpgrader`.
- Improved code clarity by replacing `FileTest.directory?` with
  `File.directory?` in `Hackmac::KextUpgrader`.

## 2020-02-13 v0.4.1

- Added support for upgrading plugins alongside kexts by introducing the
  `Hackmac::KextUpgrader` class.
- Updated the `kext_upgrade` command to use the new `KextUpgrader` instead of
  inline code, improving maintainability and readability.
- Modified the configuration file to include plugin definitions under each
  kext's source configuration.
- Removed redundant code from the `bin/efi` script by extracting the upgrade
  logic into a dedicated class.
- Added support for handling multiple kexts and their associated plugins during
  the upgrade process.

## 2020-02-11 v0.4.0

- Added dependency to the `search_ui` gem.
- Removed local implementation of `Hackmac::SearchUI` in favor of using the
  `search_ui` gem.
- Updated version number from **0.3.4** to **0.4.0**.
- Modified code to use `Search.new` instead of `SearchUI.new` when initializing
  search functionality.

## 2020-02-07 v0.3.4

- Added a new column `:path` to the table display in the `kexts` command.
- Modified the `Kext` class to store and expose the `:path` attribute.
- Updated version numbers across files to **0.3.4**.

## 2020-02-07 v0.3.3

- Added support for handling kext archives with subdirectories in the
  `kext_upgrade` command.
- Added a new development dependency: `byebug`.
- Improved error handling when unzipping kext archives by adding a failure
  check after the unzip operation.

## 2020-01-30 v0.3.2

- Modified the regular expression in `Hackmac::KextSource#download_asset` to be
  case-insensitive when matching asset names, allowing for different casing of
  the word "RELEASE".

## 2020-01-30 v0.3.1

- Updated the version number to **0.3.1** in multiple files including
  `VERSION`, `hackmac.gemspec`, and `lib/hackmac/version.rb`.
- Modified the kext upgrade process in `bin/efi`:
  - Added a check for `name` before proceeding with file operations.
  - Improved error handling by adding failure messages when the kext could not
    be installed or downloaded.
  - Changed the prompt message to include the target path and version.
- Updated the configuration file `lib/hackmac/config.rb`:
  - Renamed the device key from `boot` to `main`.

## 2020-01-30 v0.3.0

- Added the `usb` command to create a bootable USB drive for Hackintosh
  installations.
- Updated the gem specification and version files to reflect the new version
  **0.3.0**.
- Modified the `hackmac.gemspec` file to include the new `usb` executable and
  updated the list of files and extra documentation files.
- Added a new module `Hackmac::Utils` containing utility functions for command
  execution and user interaction, consolidating code previously present in
  individual scripts.
- Updated the default configuration in `lib/hackmac/config.rb` to include new
  keys for EFI source and USB OS installation media paths.
- Removed redundant code from the `bin/efi` script by including the `Utils`
  module instead of duplicating utility functions.

## 2020-01-29 v0.2.1

- Removed the `DiskUUID` column from the table display in the `list` command to
  reduce table width.

## 2020-01-29 v0.2.0

- Added a new `kext_upgrade` command to upgrade kexts from their GitHub sources
- Updated the `clone` method to use an `ask` helper function for prompts
- Added support for downloading and installing kext upgrades in a temporary
  directory
- Improved the `KextSource` class with:
  - Better handling of GitHub authentication
  - Added `download_asset` method to download release assets
  - Enhanced version parsing logic
- Updated various dependencies and internal utilities

## 2020-01-28 v0.1.1

- Updated the `hackmac` gem version from **0.1.0** to **0.1.1**
- Modified the `usage` method in `bin/efi` to use `boot_dev` instead of `dev`
- Changed the way disks are processed in `bin/efi`, using
  `disks.AllDisksAndPartitions` instead of accessing via hash
- Updated methods in `lib/hackmac/kext.rb` to use new API calls like
  `CFBundleIdentifier()`, `CFBundleName()`, and `CFBundleShortVersionString()`
  instead of direct hash access

## 2020-01-28 v0.1.0

- Added support for a configuration file to store device mappings and kext
  sources.
- Updated the `kexts` command to use the new configuration and display results
  in a formatted table using `Tabulo`.
- Changed the `boot` command to `list` which now displays boot disk information
  in a more structured format with tables.
- Added support for GitHub authentication when fetching remote kext versions.
- Improved error handling and version comparison logic for kexts.
- Added new dependencies: `complex_config` and `tabulo`.
- Updated the gemspec to include new files and updated version numbers.

## 2020-01-15 v0.0.4

- Added support for listing version info of kexts via the `kext` command, which
  takes a `PATH` argument.
- Updated the `kexts` command to display the EFI device used in the output.
- Modified the `mount` and `unmount` commands with TODO notes for future
  symlink management.
- Changed file reading in `lib/hackmac/kext.rb` to use UTF-8 encoding.
- Bumped version from **0.0.3** to **0.0.4** across all files.

## 2020-01-13 v0.0.3

- Added the ability to display the kext version and all kexts
- Updated the command from `kext` to `kexts`
- Modified the help message for the `kexts` command
- Added a new `kext` command that takes an app directory as input

## 2020-01-13 v0.0.2

- Made the device configurable in the `efi` script by allowing it to accept a
  custom mount point via command line arguments.
- Updated the version number from **0.0.1** to **0.0.2** across all relevant
  files including `VERSION`, `hackmac.gemspec`, and `lib/hackmac/version.rb`.
- Modified the date in the gem specification file to reflect the latest commit
  date of 2020-01-13.

## 2020-01-06 v0.0.1

- Added a `boot` command to the `efi` tool that shows boot disk information,
  specifically which EFI partition was used.
- Updated the `help` command in the `efi` tool to include detailed usage
  instructions for all available commands: `mount`, `unmount`, `clone`, `kext`,
  and `boot`.
- Bumped the version number from **0.0.0** to **0.0.1** across all relevant
  files.
- Updated the gemspec file to reflect the new version **0.0.1**, updated the
  date, and adjusted RubyGems version compatibility.

## 2019-12-18 v0.0.0

  * Start
