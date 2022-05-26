module Hackmac
  include Hackmac::AssetTools

  class OCValidator
    def initialize(mdev:, config:)
      @config = config
      mount_path   = Pathname.new('/Volumes').join(mdev)
      @config_plist =
        Pathname.new(mount_path).join(@config.oc.efi_path).join('OC/config.plist')
    end

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
