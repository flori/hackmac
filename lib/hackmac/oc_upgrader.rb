require 'fileutils'

module Hackmac
  # A class that handles the upgrade process for OpenCore bootloader files
  #
  # The OCUpgrader class manages the workflow for upgrading OpenCore bootloader
  # installations by retrieving remote release information, downloading and
  # decompressing new versions, and performing file system operations to replace
  # existing EFI files after ensuring the installation directory is properly
  # configured
  #
  # @example
  #   upgrader = Hackmac::OCUpgrader.new(mdev: '/dev/disk1', config: config_obj)
  #   upgrader.perform
  #   # Executes the OpenCore upgrade process in a temporary directory context
  class OCUpgrader
    include FileUtils::Verbose
    include Hackmac::AssetTools

    # The initialize method sets up an OCUpgrader instance by configuring the
    # installation directory based on the provided mount point and
    # configuration.
    #
    # This method takes a mount device identifier and configuration object,
    # then constructs the full path to the EFI installation directory by
    # joining the mount path with the OpenCore EFI path specified in the
    # configuration.
    #
    # @param mdev [ String ] the mount device identifier for the EFI partition
    # @param config [ Object ] the configuration object containing OpenCore settings including the EFI path
    #
    # @return [ void ] Returns nothing but initializes instance variables for the upgrade process
    def initialize(mdev:, config:)
      @config      = config
      mount_path   = Pathname.new('/Volumes').join(mdev)
      @install_dir = Pathname.new(mount_path).join(@config.oc.efi_path)
    end

    # The perform method executes the OpenCore upgrade process by isolating the
    # operation in a temporary directory
    #
    # This method handles the complete workflow for upgrading OpenCore
    # bootloader files, including retrieving remote release information,
    # downloading and decompressing the new version, and performing file system
    # operations to replace existing EFI files after ensuring
    # the installation directory is properly configured
    #
    # @return [ void ] Returns nothing but performs file system operations and
    #   user interaction
    # @raise [ RuntimeError ] raised when a remote download fails or when no
    #   source is defined for the OpenCore upgrade
    def perform
      isolate do |dir|
        oc = OC.new(config: @config)
        name, data = oc.remote.download_asset
        if name
          File.secure_write(name, data)
          decompress(name)
          for f in @config.oc.files.map { |x| Pathname.new(x) }
            sf = Pathname.new(dir).join(@config.oc.install_path).join(f)
            cp sf, @install_dir.join(f.dirname)
          end
        else
          fail "#{oc} could not be downloaded"
        end
      end
    end

    # The to_s method returns a string representation of the object by
    # formatting the installation directory path into a descriptive string
    # that indicates where the OpenCore files will be installed
    #
    # @return [ String ] a formatted string containing the installation path
    #   in the format "Installation into /path/to/installation/directory"
    def to_s
      'Installation into %s' % @install_dir
    end
  end
end
