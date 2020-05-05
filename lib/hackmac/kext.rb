require 'hackmac/plist'
require 'pathname'
require 'tins/string_version'

module Hackmac
  class Kext
    include Hackmac::Plist
    include Tins::StringVersion

    def initialize(path:, config: nil)
      @path   = path
      info    = Pathname.new(@path) + 'Contents/Info.plist'
      @plist  = File.open(info, encoding: 'UTF-8') { |f| ::Plist.parse_xml(f) }
      @config = config
    end

    attr_reader :path

    def identifier
      CFBundleIdentifier()
    end

    def name
      CFBundleName() || File.basename(identifier)
    end

    def version
      unless @version
        if version = CFBundleShortVersionString()
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
      return @remote_kext if @remote_kext
      if @config
        if source = @config.kext.sources[name] and github = source&.github
          auth = [ @config.github.user, @config.github.access_token ].compact
          auth.empty? and auth = nil
          suffix = source.debug? ? 'DEBUG' : 'RELEASE'
          @remote_kext = Hackmac::KextSource.new(github, auth: auth, suffix: suffix)
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
