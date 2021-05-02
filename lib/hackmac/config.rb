require 'complex_config/shortcuts'
require 'tins/xt/secure_write'
require 'fileutils'
require 'pathname'

module Hackmac
  module Config
    extend FileUtils
    extend ComplexConfig::Provider::Shortcuts

    DEFAULT = <<~end
      ---
      efi:
        source: 'https://github.com/flori/EFI-some.git'
      usb:
        os: '/Applications/Install macOS Mojave.app'
      devices:
        main:
          name: 'OSX_EFI'
        backup:
          name: 'BACKUP_EFI'
      github:
        user: null
        access_token: null
      kext:
        efi_path: 'EFI/CLOVER/kexts/Other'
        sources:
          AppleALC:
            github: 'acidanthera/AppleALC'
          IntelMausi:
            github: 'acidanthera/IntelMausi'
          Lilu:
            github: 'acidanthera/Lilu'
          #USBInjectAll:
          #  github: 'Sniki/OS-X-USB-Inject-All'
          VirtualSMC:
            github: 'acidanthera/VirtualSMC'
            debug: false
            plugins:
              - SMCProcessor
              - SMCSuperIO
          BrcmPatchRAM2:
            github: 'acidanthera/BrcmPatchRAM'
            plugins:
              - BrcmFirmwareData
          WhateverGreen:
            github: 'acidanthera/WhateverGreen'
    end

    def self.load(path: ENV.fetch('CONFIG_PATH', '~/.config/hackmac/hackmac.yml'))
      path = Pathname.new(path).expand_path
      mkdir_p path.dirname
      ComplexConfig::Provider.config_dir = path.dirname
      unless path.exist?
        File.secure_write(path, DEFAULT)
      end
      puts "Loading config from #{path.to_s.inspect}."
      ComplexConfig::Provider[path.basename.to_s.sub(/\..*?\z/, '')]
    end
  end
end
