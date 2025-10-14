require 'hackmac/plist'
require 'pathname'
require 'tins/string_version'

module Hackmac

  # A class that represents a kernel extension (kext) and provides access to
  # its metadata and remote version information
  #
  # The Kext class encapsulates the functionality for working with macOS kernel
  # extensions, including loading their Info.plist files, extracting metadata
  # such as identifiers and versions, and determining whether newer versions
  # are available from remote sources
  #
  # @example
  #   kext = Hackmac::Kext.new(path: '/path/to/MyKext.kext')
  #   # Provides access to kext metadata through method calls
  class Kext
    include Hackmac::Plist
    include Tins::StringVersion

    # The initialize method sets up a Kext instance by loading and parsing its
    # Info.plist file
    #
    # This method takes a path to a kext directory and optionally a
    # configuration object, then reads the Info.plist file within the kext's
    # Contents directory to extract metadata about the kernel extension. The
    # plist data is parsed and stored for later access through dynamic method
    # calls.
    #
    # @param path [ String ] the filesystem path to the kext directory
    # @param config [ Object, nil ] optional configuration object that may provide source information
    def initialize(path:, config: nil)
      @path   = path
      info    = Pathname.new(@path) + 'Contents/Info.plist'
      @plist  = File.open(info, encoding: 'UTF-8') { |f| ::Plist.parse_xml(f) }
      @config = config
    end

    # The path reader method provides access to the path attribute that was set
    # during object initialization.
    #
    # This method returns the value of the path instance variable, which
    # typically represents the filesystem path associated with the object.
    #
    # @return [ String ] the path value stored in the instance variable
    attr_reader :path

    # The identifier method retrieves the bundle identifier from the kext's
    # Info.plist file
    #
    # This method accesses the CFBundleIdentifier key from the parsed plist
    # data of a kernel extension, providing the unique identifier that
    # distinguishes this particular kext within the system
    #
    # @return [ String ] the bundle identifier of the kernel extension
    # @return [ nil ] returns nil if the CFBundleIdentifier key is not present in the plist
    def identifier
      CFBundleIdentifier()
    end

    # The name method retrieves the display name for the kernel extension
    #
    # This method attempts to return the CFBundleName value from the kext's
    # Info.plist file and falls back to using the basename of the bundle
    # identifier if that value is not present
    #
    # @return [ String ] the human-readable name of the kernel extension
    # @return [ nil ] returns nil if neither CFBundleName nor identifier is available
    def name
      CFBundleName() || File.basename(identifier)
    end

    # The version method retrieves and caches the version identifier from the
    # kext's Info.plist file
    #
    # This method attempts to extract the CFBundleShortVersionString value from
    # the parsed plist data and convert it into a Version object for proper
    # semantic versioning comparison. If the version string is not a valid
    # semantic version, it stores the raw string instead.
    #
    # @return [ Tins::StringVersion, String, nil ] the version object or string if found, nil otherwise
    def version
      unless @version
        if version = CFBundleShortVersionString()
          if version =~ /\A\d+\.\d+\.\d+\z/
            begin
              @version = Version.new(version)
            rescue ArgumentError
              @version = version
            end
          end
        end
      end
      @version
    end

    # The remote_kext method retrieves or creates a remote source object for a
    # kext
    #
    # This method attempts to return an existing cached remote kext source or
    # constructs a new one based on the configuration source for this kext. It
    # supports both GitHub-based sources and direct URL downloads, determining
    # the appropriate source type from the configuration and creating the
    # corresponding source object.
    #
    # @return [ Hackmac::GithubSource, Hackmac::URLDownload, nil ] returns the remote
    #   source object if a configuration source exists, or nil if no source is
    #   configured or the kext has no associated configuration
    def remote_kext
      return @remote_kext if @remote_kext
      if @config
        source = @config.kext.sources[name] or return
        case
        when github = source&.github?
          auth = [ @config.github.user, @config.github.access_token ].compact
          auth.empty? and auth = nil
          suffix =
            case debug = source.debug?
            when true       then 'DEBUG'
            when false      then 'RELEASE'
            when nil        then nil
            end
          @remote_kext = Hackmac::GithubSource.new(github, auth: auth, suffix: suffix)
        when download = source&.download
          @remote_kext = Hackmac::URLDownload.new(download.name, download.version, download.url)
        end
      end
    end

    # The remote_version method retrieves the version identifier from the
    # remote kext source
    #
    # This method accesses the cached remote kext source object and returns its
    # version information if available. It uses the safe navigation operator to
    # avoid errors when the remote kext source has not been initialized or does
    # not have version data
    #
    # @return [ Tins::StringVersion, String, nil ] the version object or string from
    #   the remote source, or nil if no remote source is available or has no version
    #   information
    def remote_version
      remote_kext&.version
    end

    # The inspect method returns a string representation of the object
    # that includes its class name and string value
    #
    # @return [ String ] a formatted string containing the object's class name
    #   and its string representation
    def inspect
      "#<#{self.class}: #{to_s}>"
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
