module Hackmac
  include Hackmac::AssetTools
  # A class that handles validation of OpenCore bootloader configurations
  #
  # The OCValidator class provides functionality for verifying the correctness
  # and compatibility of OpenCore EFI configuration files. It retrieves the
  # latest OpenCore release, downloads the necessary validation utilities, and
  # executes validation checks against a specified configuration plist file to
  # ensure it meets the required standards for OpenCore bootloaders.
  #
  # @example
  #   validator = Hackmac::OCValidator.new(mdev: '/dev/disk1', config: config_obj)
  #   # Configures validation for an OpenCore installation on a specific disk
  class OCValidator
    # The initialize method sets up an OCValidator instance by configuring the
    # path to the OpenCore configuration plist file
    #
    # This method takes a mount device identifier and configuration object,
    # then constructs the full path to the OpenCore configuration plist file by
    # joining the mount path with the EFI path and OC subdirectory specified in
    # the configuration
    #
    # @param mdev [ String ] the mount device identifier for the EFI partition
    # @param config [ Object ] the configuration object containing OpenCore settings including the EFI path
    def initialize(mdev:, config:)
      @config = config
      mount_path   = Pathname.new('/Volumes').join(mdev)
      @config_plist =
        Pathname.new(mount_path).join(@config.oc.efi_path).join('OC/config.plist')
    end

    # The perform method executes the OpenCore configuration validation process
    #
    # This method handles the complete workflow for validating an OpenCore
    # configuration file by retrieving the latest OpenCore release, downloading
    # the validation utilities, and running the ocvalidate tool against the
    # specified configuration plist file
    #
    # @return [ Boolean ] returns true if validation succeeds, false if validation fails
    # @raise [ RuntimeError ] raised when the OpenCore download fails or when no
    #                         remote source is defined for the OpenCore upgrade
    def perform
      isolate do |dir|
        oc = OC.new(config: @config)
        name, data = oc.remote.download_asset
        if name
          File.secure_write(name, data)
          decompress(name)
          result = %x(Utilities/ocvalidate/ocvalidate #{@config_plist.to_s.inspect} 2>&1)
          if $?.success?
            STDERR.puts result
            true
          else
            STDERR.puts "Validation has failed!", "", result
            false
          end
          true
        else
          fail "#{oc} could not be downloaded"
        end
      end
    end
  end
end
