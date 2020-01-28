require 'hackmac/plist'
require 'pathname'
require 'tins/string_version'

module Hackmac
  class Kext
    include Hackmac::Plist
    include Tins::StringVersion

    def initialize(path:, config: nil)
      @path   = Pathname.new(path) + 'Contents/Info.plist'
      @plist  = File.open(@path, encoding: 'UTF-8') { |f| ::Plist.parse_xml(f) }
      @config = config
    end

    def identifier
      as_hash['CFBundleIdentifier']
    end

    def name
      as_hash['CFBundleName'] || File.basename(identifier)
    end

    def version
      unless @version
        if version = as_hash['CFBundleShortVersionString']
          begin
            @version = Version.new(version)
          rescue ArgumentError
            @version = version
          end
        end
      end
      @version
    end

    def remote_kext
      if @config
        if github = @config.kext.sources[name]&.github
          auth = [ @config.github.user, @config.github.access_token ].compact
          auth.empty? and auth = nil
          @remote_kext = Hackmac::KextSource.new(github, auth: auth)
        end
      end
    end

    def remote_version
      remote_kext&.version
    end

    def inspect
      "#<#{self.class}: #{to_s}>"
    end

    def to_s
      "#{name} #{version}"
    end
  end
end
