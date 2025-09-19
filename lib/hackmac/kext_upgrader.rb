require 'fileutils'
require 'find'
require 'pathname'

module Hackmac
  # A class that handles the upgrade process for kernel extensions (kexts)
  #
  # The KextUpgrader class manages the workflow for upgrading macOS kernel extensions
  # by checking remote version availability, downloading new versions, and performing
  # file system operations to replace existing kext files after user confirmation
  #
  # @example
  #   upgrader = Hackmac::KextUpgrader.new(path: '/path/to/kext', config: config_obj)
  #   upgrader.perform
  #   # Executes the kext upgrade process in a temporary directory context
  class KextUpgrader
    include FileUtils
    include Hackmac::AssetTools

    # The initialize method sets up a KextUpgrader instance by storing the
    # provided path, configuration, and force flag.
    #
    # This method takes the necessary parameters to configure the kext
    # upgrader, including the filesystem path to the kext, the configuration
    # object that defines source information, and a force flag that determines
    # whether upgrades should be performed even when the remote version is not
    # newer than the local version.
    #
    # @param path [ String ] the filesystem path to the kext directory that
    #   needs upgrading
    # @param config [ Object ] the configuration object containing source
    #   information for the kext
    # @param force [ TrueClass, FalseClass ] flag indicating whether to force
    #   upgrade even if remote version is not newer
    def initialize(path:, config:, force: false)
      @path, @config, @force = path, config, force
    end

    public

    # The perform method executes the kext upgrade process by isolating the
    # operation in a temporary directory
    #
    # This method handles the complete workflow for upgrading a kernel
    # extension, including checking for remote version availability,
    # downloading and decompressing the new version, identifying target
    # installation paths, and performing the actual file replacement after user
    # confirmation
    #
    # @return [ void ] Returns nothing but performs file system operations and
    #   user interaction
    # @raise [ RuntimeError ] raised when a remote download fails or when no
    #   source is defined for the kext
    def perform
      isolate do |dir|
        kext = Kext.new(path: @path, config: @config)
        case
        when kext.remote_version.nil?
          puts "No source defined for #{kext}"
        when (kext.remote_version > kext.version rescue false) || @force
          name, data = kext.remote_kext.download_asset
          if name
            File.secure_write(name, data)
            decompress(name)
            kext_pathes = []
            Find.find(dir) do |path|
              if File.directory?(path)
                case File.basename(path)
                when /\A\./
                  Find.prune
                when "#{kext.name}.kext"
                  kext_pathes.unshift path
                when
                  *@config.kext.sources[kext.name]&.plugins?&.map { |p| p + '.kext' }
                then
                  kext_pathes << path
                end
              end
            end
            kext_pathes.each do |kext_path|
              old_path = (Pathname.new(@path).dirname + File.basename(kext_path)).to_s
              if ask("Really upgrade #{old_path.inspect} to version #{kext.remote_version}? (y/n) ")
                rm_rf old_path
                cp_r kext_path, old_path
              end
            end
          else
            fail "#{kext.remote_kext.name} could not be downloaded"
          end
        else
          puts "#{kext} is already the latest version"
        end
      end
    end
  end
end
