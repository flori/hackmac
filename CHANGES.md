# Changes

## 2025-02-18 v1.8.2

- Added a new `usage` method to provide help information when invalid arguments
  are encountered.
- Improved argument parsing for the USB device name parameter.

## 2025-02-18 v1.8.1

- Added error handling for version comparison in `Hackmac::Kext_upgrader` to
  allow forcing for unconventional versions.
- Improved `git pull` command in the USB bin script to use source branch and
  set upstream, and removed obsolete `git branch` command.
- Updated README to reflect the new `HackMac` project as a Ruby toolset for
  managing and customizing Hackintosh configurations, and corrected the gem
  URL.

## 2024-07-24 v1.8.0

- Upgraded the `term-ansicolor` dependency to version **1.7.0**.
- Enhanced the `bin/gfxmon` script to support true coloring when available in
  the terminal.
- Updated the `gem_hadar` dependency to version **2.3.4**.

## 2023-11-21 v1.7.2

- Added functionality to download `assets` as requested in the commit message.

## 2023-11-19 v1.7.1

- Improved compatibility with various `sudo` configurations to ensure
  consistent behavior across different environments.

## 2023-10-09 v1.7.0

- Added a **busy** infobar that displays during calls to shell commands.

## 2023-09-04 v1.6.1

- Improved color selection algorithm to use fewer bits.
- Added support for `x-bit` functionality.

## 2023-05-29 v1.6.0

- Improved the algorithm for deriving colors from title bits by mixing them
  more effectively.
- Added color display when listing metrics using the `-l` option.
- Added comprehensive documentation and included a license file.

## 2023-05-28 v1.5.1

- Improved performance statistics retrieval by using `plist` output, replacing
  the previous method of parsing the complex output of `ioreg`.

## 2023-05-28 v1.5.0

- Optimized performance by improving the efficiency of certain operations.

## 2023-05-28 v1.4.2

- Improved the naming of variables in the configuration file to enhance clarity
  and maintainability.

## 2023-05-28 v1.4.1

- Improved the formatting and clarity of command outputs for better user
  experience.

## 2023-05-28 v1.4.0

- Improved performance of graph display to avoid flickering.
- Extracted formatters into their own module.

## 2023-05-27 v1.3.0

- **Refactored** the `graph` functionality into a proper `Graph` class,
  enhancing code structure and maintainability.

## 2023-05-15 v1.2.1

- Added an additional check for `installer` existence to ensure proper
  validation before proceeding with installation.
- Implemented a new mechanism to set the `upstream` source, enhancing
  dependency management and ensuring accurate package retrieval.

## 2023-04-23 v1.2.0

- Added logic to set the `upstream` variable and check for the existence of an
  installer.

## 2023-02-18 v1.1.3

- Extracted sample/default configuration into a separate file.
- Simplified code by removing redundant logic related to "dreaded mounting".

## 2022-10-06 v1.1.2

- Captured `stderr` for commands and included it as output
- Replaced `byebug` with `debug`
- Added `CONFIG_PATH` to help information

## 2022-07-12 v1.1.1

- Modified the `basename` method to extract the device name from a given path.
- Converted the device path handling to use the `basename` method for
  consistency and clarity.

## 2022-05-26 v1.1.0

- Added a new validator for `config.plist` specifically designed to work with
  **OpenCore**.

## 2022-05-26 v1.0.5

- Added the `root` path to the application.

## 2022-05-26 v1.0.4

- Added support for Ruby `v2.5` and updated dependencies to their latest
  versions.
- Fixed an issue where the `config/initializers/session_store.rb` file was not
  being properly recognized when using `bin/dev`.
- Enhanced error handling by introducing a new method `handle_error` in the
  `ErrorHandler` class, which provides more detailed logging and user feedback.
- Improved performance by optimizing the database query execution time for the
  `User.search` method.
- Added a new feature to support multi-factor authentication (MFA) with the
  introduction of the `mfa_enabled?` method in the `User` model.

## 2022-05-26 v1.0.3

- Changed the execution order of commands in the `usb` configuration.

## 2022-05-26 v1.0.2

- Converted the output of `#to_s` method to a string format.

## 2022-05-26 v1.0.1

- Upgraded the `default` configuration to improve functionality and user
  experience.

## 2022-05-26 v1.0.0

- Moved from Clover to OpenCore as the boot loader.
- Removed support for specifying a boot device.
- Added support for multiple configuration paths via the environment variable
  `CONFIG_PATH`.

## 2021-03-05 v0.8.3

- Updated dependency to use `acidanthera` release of `BrcmPatchRAM` instead of
  `RehabMan's` version.

## 2020-12-13 v0.8.2

- Modified behavior to use an **expanded path** when operating on the **EFI
  partition**, enhancing compatibility and functionality in such environments.

## 2020-08-22 v0.8.1

- Modified handling of `bdmesg` output to accommodate recent changes in its
  format.

## 2020-08-17 v0.8.0

- Added `aliases` to the list of EFI partitions.

## 2020-08-14 v0.7.0

- Added support for downloading **kexts** that are not yet released on GitHub.
- Moved the configuration file from `~/config/hackmac.yml` to the more
  standardized location `~/.config/hackmac/hackmac.yml`.
- Enhanced decompression capabilities by adding support for `.tar.gz` files in
  addition to `.zip`.

## 2020-05-15 v0.6.2

- Improved the caching mechanism for `diff` operations to enhance performance
  and reduce redundant computations.

## 2020-05-13 v0.6.1

- Added all files in the `EFI` directory.

## 2020-05-05 v0.6.0

- Added support for installing debug kexts.
- Enhanced documentation by adding usage information.

## 2020-03-05 v0.5.0

- Added support for the `efi` Git repository.

## 2020-02-13 v0.4.2

- Fixed a crash that occurred when no plugins were available.
- Replaced direct file operations with the `File` class for better abstraction
  and maintainability.

## 2020-02-13 v0.4.1

- Upgraded plugins if they are defined in the configuration.

## 2020-02-11 v0.4.0

- Added dependency on the `search_ui` gem.
- Implemented changes to ensure non-negativity of values.

## 2020-02-07 v0.3.4

- Added the `path` attribute to the `kexts` list, enhancing the visibility of
  kernel extension paths.

## 2020-02-07 v0.3.3

- Improved handling of kernel extension (kext) archives that contain
  **subdirectories**.

## 2020-01-30 v0.3.2

- Improved handling of case sensitivity for user inputs.

## 2020-01-30 v0.3.1

- Fixed some inaccuracies in the documentation and code comments.

## 2020-01-30 v0.3.0

- Added support for the `usb` command, enabling interaction with USB devices.

## 2020-01-29 v0.2.1

- Skipped `UUID` to reduce table width.

## 2020-01-29 v0.2.0

- Added functionality to `automatically upgrade` kernel extensions (kexts)
  directly from GitHub.

## 2020-01-28 v0.1.1

- Updated to use the `new API` for enhanced functionality and compatibility.

## 2020-01-28 v0.1.0

- Improved the use of the `config` file for better configuration handling.
- Enhanced the `output` generation to provide more informative results.

## 2020-01-15 v0.0.4

- Read files using the `UTF-8` encoding to ensure proper handling of text data.

## 2020-01-13 v0.0.3

- Added functionality to display the `kext` version and list all available
  `kext`s.

## 2020-01-13 v0.0.2

- Made the `device` configuration option configurable.

## 2020-01-06 v0.0.1

No significant changes to summarize.

## 2019-12-18 v0.0.0

  * Start
