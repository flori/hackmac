require 'open-uri'
require 'tins/string_version'

module Hackmac
  class URLDownload
    include Tins::StringVersion

    def initialize(name, version, url)
      @name    = name
      @url     = url
      @version = Version.new(version)
    end

    attr_reader :name

    attr_reader :version

    def download_asset
      data = URI.open(
        @url,
        'Accept' => 'application/octet-stream',
        &:read
      )
      return File.basename(@url), data
    end

    def inspect
      "#<#{self.class}: #{to_s}>"
    end

    def to_s
      "#{name} #{version}"
    end

    def to_s
      "#{name} #{version}"
    end
  end
end
