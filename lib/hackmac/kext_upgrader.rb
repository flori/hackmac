require 'fileutils'
require 'find'
require 'pathname'

module Hackmac
  class KextUpgrader
    include FileUtils

    def initialize(path:, config:)
      @path, @config = path, config
    end

    private

    def isolate
      Dir.mktmpdir do |dir|
        cd dir do
          yield dir
        end
      end
    end

    public

    def perform
      isolate do |dir|
        kext = Kext.new(path: @path, config: @config)
        case
        when kext.remote_version.nil?
          puts "No source defined for #{kext}"
        when kext.remote_version > kext.version
          name, data = kext.remote_kext.download_asset
          if name
            File.secure_write(name, data)
            system "unzip #{name.inspect}" or fail "Could not unzip #{name.inspect}"
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
            p kext_pathes
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
