module Hackmac
  # A class that represents an OpenCore configuration and provides access to
  # its remote version information
  #
  # The OC class encapsulates the functionality for working with OpenCore
  # bootloader configurations, including retrieving remote release information
  # from GitHub sources and providing access to version metadata for comparison
  # and upgrade operations
  #
  # @example
  #   oc = Hackmac::OC.new(config: config_obj)
  #   # Provides access to OpenCore version information through method calls
  class OC
    # The initialize method sets up an OC instance by storing the provided
    # configuration object.
    #
    # This method takes a configuration object and assigns it to an instance
    # variable for later use in accessing OC-related settings and source
    # information.
    #
    # @param config [ Object ] the configuration object containing OC-specific
    #   settings and source definitions
    def initialize(config:)
      @config = config
    end

    # The remote method retrieves or creates a remote source object for
    # OpenCore
    #
    # This method manages the initialization and caching of a remote source
    # object that provides access to OpenCore release information from GitHub.
    # It constructs the appropriate source configuration including
    # authentication credentials and version suffix based on debug settings,
    # then creates a GithubSource instance to handle communication with the
    # GitHub API for retrieving release data
    #
    # @return [ Hackmac::GithubSource ] the cached remote source object for
    #   OpenCore releases
    # @return [ nil ] returns nil if no OpenCore source is configured in the
    #   configuration
    def remote
      @remote and return @remote
      source = @config.oc.source
      github = source.github
      auth = [ @config.github.user, @config.github.access_token ].compact
      auth.empty? and auth = nil
      suffix =
        case debug = source.debug?
        when true       then 'DEBUG'
        when false      then 'RELEASE'
        when nil        then nil
        end
      @remote = Hackmac::GithubSource.new(github, auth: auth, suffix: suffix)
    end

    # The name method retrieves the name attribute from the remote source
    # object
    #
    # This method accesses the cached remote source object and returns its name
    # information if available. It uses the safe navigation operator to avoid
    # errors when the remote source has not been initialized
    #
    # @return [ String, nil ] the name value from the remote source, or nil if no remote source is available
    def name
      remote.name
    end

    # The version method retrieves the version identifier from the remote kext
    # source
    #
    # This method accesses the cached remote kext source object and returns its
    # version information if available. It serves as a delegate to the
    # remote_kext's version attribute, providing convenient access to the
    # latest version data for the kext
    #
    # @return [ Tins::StringVersion, String, nil ] the version object or string from
    #   the remote source, or nil if no remote source is available or has no version
    #   information
    def version
      remote.version
    end

    # The inspect method returns a string representation of the object that
    # includes its class name and string value.
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
    # @return [ String ] a formatted string containing the name and version
    #   separated by a space
    def to_s
      "#{name} #{version}"
    end
  end
end
