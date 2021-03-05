require 'complex_config/shortcuts'
require 'tins/xt/secure_write'
require 'fileutils'

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

    def self.load
      path = File.expand_path('~/.config/hackmac')
      mkdir_p path
      ComplexConfig::Provider.config_dir = path
      config_path = File.join(path, 'hackmac.yml')
      unless File.exist?(config_path)
        File.secure_write(config_path, DEFAULT)
      end
      complex_config.hackmac
    end
  end
end
