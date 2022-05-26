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
        source: 'storage.gate.ping.de:/git/EFI-hacmaxi.git'
      usb:
        os: '/Applications/Install macOS Monterey.app'
      devices:
        main:
          name: 'EFI'
        backup:
          name: 'BACKUP_EFI'
      github:
        user: null
        access_token: null
      oc:
        efi_path: 'EFI'
        source:
          github: 'acidanthera/OpenCorePkg'
          debug: true
        install_path: 'X64/EFI'
        files:
          - 'BOOT/BOOTx64.efi'
          - 'OC/OpenCore.efi'
          - 'OC/Drivers/OpenHfsPlus.efi'
          - 'OC/Drivers/OpenRuntime.efi'
          - 'OC/Tools/OpenShell.efi'
      kext:
        efi_path: 'EFI/OC/Kexts'
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
          LucyRTL8125Ethernet:
            github: 'Mieze/LucyRTL8125Ethernet'
    end

    def self.load(path: ENV.fetch('CONFIG_PATH', '~/.config/hackmac/hackmac.yml'))
      path = Pathname.new(path).expand_path
      mkdir_p path.dirname
      ComplexConfig::Provider.config_dir = path.dirname
      unless path.exist?
        File.secure_write(path.to_s, DEFAULT)
      end
      puts "Loading config from #{path.to_s.inspect}."
      ComplexConfig::Provider[path.basename.to_s.sub(/\..*?\z/, '')]
    end
  end
end
