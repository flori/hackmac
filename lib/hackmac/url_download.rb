require 'open-uri'
require 'tins/string_version'

module Hackmac
  # A class that provides functionality for downloading assets from URLs with
  # version tracking
  #
  # The URLDownload class encapsulates the logic for managing downloadable
  # assets by storing their name, version, and download URL. It provides
  # methods to retrieve the asset data and metadata, making it suitable for use
  # in systems that need to track and download software components from web
  # sources.
  #
  # @example
  #   downloader = Hackmac::URLDownload.new('Foo', '1.0.0', 'https://example.com/foo.zip')
  #   # Configures a download source with name, version, and URL for later retrieval
  class URLDownload
    include Tins::StringVersion

    # The initialize method sets up a URLDownload instance by storing the
    # provided name, URL, and version information.
    #
    # This method takes the necessary parameters to configure the download
    # source and converts the version string into a Version object for later
    # comparison.
    #
    # @param name [ String ] the descriptive name of the downloadable asset
    # @param version [ String ] the version identifier to be parsed and stored
    # @param url [ String ] the web address where the asset can be retrieved
    def initialize(name, version, url)
      @name    = name
      @url     = url
      @version = Version.new(version)
    end

    # The name reader method provides access to the name attribute that was set
    # during object initialization.
    #
    # This method returns the value of the name instance variable, which
    # typically represents the descriptive identifier or label associated with
    # the object.
    #
    # @return [ String ] the name value stored in the instance variable
    attr_reader :name

    # The version reader method provides access to the version attribute that
    # was set during object initialization.
    #
    # This method returns the value of the version instance variable, which
    # typically represents the semantic version number associated with the
    # object's current state or configuration.
    #
    # @return [ String, nil ] the version value stored in the instance variable, or nil if not set
    attr_reader :version

    # The download_asset method retrieves binary data from a configured URL
    #
    # This method performs an HTTP GET request to the stored URL to download
    # the associated asset file. It returns both the filename derived from
    # the URL and the raw binary data content.
    #
    # @return [ Array<String, String> ] an array containing the filename and downloaded data
    # @return [ nil ] returns nil if no URL is configured for this instance
    def download_asset
      data = URI.open(
        @url,
        'Accept' => 'application/octet-stream',
        &:read
      )
      return File.basename(@url), data
    end

    # The inspect method returns a string representation of the object that
    # includes its class name and string value
    #
    # @return [ String ] a formatted string containing the object's class name
    #   and its string representation
    def inspect
      "#<#{self.class}: #{to_s}>"
    end

    # The to_s method returns a string representation of the object by
    # combining its name and version attributes into a single
    # space-separated string.
    #
    # @return [ String ] a formatted string containing the name and version
    #   separated by a space
    def to_s
      "#{name} #{version}"
    end

    # The to_s method returns a string representation of the object by
    # combining its name and version attributes into a single space-separated
    # string.
    #
    # @return [ String ] a formatted string containing the name and version separated by a space
    def to_s
      "#{name} #{version}"
    end
  end
end
