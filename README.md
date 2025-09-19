# HackMac 🚀

## Description 📝

HackMac is a set of Ruby tools specifically designed for managing and
customizing Hackintosh configurations. While primarily intended for users with
Hackintosh setups, it may also be useful for ordinary Mac users who want to
leverage its features for monitoring system performance using `gfxmon`.

## Tools 🛠️

### `efi` - EFI Partition Management 📁
Manage OpenCore EFI partitions including:
- Upgrading OpenCore and kernel extensions (kexts) 🔧
- Committing changes to git repositories 💾
- Mounting/unmounting EFI volumes 📌
- Cloning EFI partitions between devices 🔄

### `usb` - Bootable USB Creator 🖥️
Create bootable USB drives for macOS installation with:
- Format USB device with GPT partition scheme 📊
- Create bootable installer using Apple's `createinstallmedia` ⚡
- Initialize git repository on EFI partition 📦

### `gfxmon` - GPU Performance Monitor 🎮
Display real-time performance statistics for your GPU in the terminal including:
- Temperature, clock rates, fan rotations 🌡️
- Memory usage and power consumption ⚡
- Color-coded visualizations with ANSI terminal graphics 🎨

![gfxmon Screenshot](./img/gfxmon.png "gfxmon Screenshot")

## Installation 📦

### Using RubyGems 💎
```bash
gem install hackmac
```

### Using Bundler 📦
Add to your Gemfile:
```ruby
gem 'hackmac'
```

## Configuration ⚙️

First run `efi` without arguments to display available commands and initialize
the default configuration file at:
```
~/.config/hackmac/hackmac.yml
```

To use a custom configuration file, set the environment variable:
```bash
export HACKMAC_CONFIG=~/config/hackmac/other.yml
```

## Usage Examples 🎯

### EFI Management 📁
```bash
# Mount EFI partition
efi mount

# Clone EFI partitions
efi clone /dev/disk0s1 /dev/disk1s1

# Upgrade OpenCore
efi oc_upgrade

# Show kext versions
efi kexts
```

### GPU Monitoring 🎮
```bash
# Real-time monitoring with 2-second updates
gfxmon -n 2

# Monitor specific metric
gfxmon -m "Temperature(C)"

# Output as JSON for scripting
gfxmon -j
```

### USB Creation 🖥️
```bash
# Create bootable USB
usb /dev/disk2
```

## Download 🌐

The homepage of this library is located at:
https://github.com/flori/hackmac

## Author 👨‍💻

[Florian Frank](mailto:flori@ping.de)

## License 📄

This software is licensed under the [MIT license](LICENSE). ✅
