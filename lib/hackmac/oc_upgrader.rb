require 'fileutils'

module Hackmac
  class OCUpgrader
    include FileUtils::Verbose
    include Hackmac::AssetTools

    def initialize(mdev:, config:)
      @config      = config
      mount_path   = Pathname.new('/Volumes').join(mdev)
      @install_dir = Pathname.new(mount_path).join(@config.oc.efi_path)
    end

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

    def to_s
      'Installation into %s' % @install_dir
    end
  end
end
