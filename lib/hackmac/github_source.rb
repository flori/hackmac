require 'open-uri'
require 'json'
require 'tins/string_version'

module Hackmac
  # A class that provides functionality for fetching and processing release
  # information from GitHub repositories
  #
  # The GithubSource class enables interaction with GitHub's API to retrieve
  # release data for a specified repository
  #
  # It parses release information to identify the latest version and provides
  # methods for downloading associated assets
  #
  # @example
  #   source = Hackmac::GithubSource.new('owner/repo', auth: ['user', 'token'])
  #   # Fetches latest release information and allows asset downloads
  class GithubSource
    GITHUB_API_URL = 'https://api.github.com/repos/%s/releases'

    include Tins::StringVersion

    # The initialize method sets up a GithubSource instance by fetching and
    # parsing release information from the GitHub API.
    #
    # This method takes a GitHub repository identifier and optional
    # authentication credentials, then retrieves all releases for that
    # repository via the GitHub API. It processes the release data to find the
    # highest version number, extracts relevant metadata about that release,
    # and stores the release information for later use in downloading assets.
    #
    # @param github [ String ] the GitHub repository identifier in the format
    #   "owner/repo"
    # @param auth [ Array<String>, nil ] optional basic authentication
    #   credentials [username, token]
    # @param suffix [ String, nil ] optional suffix to filter asset names when
    #   downloading
    def initialize(github, auth: nil, suffix: nil)
      @github  = github
      @auth    = auth
      @suffix  = (Regexp.quote(suffix) if suffix)
      _account, repo = github.split(?/)
      @name = repo
      releases = URI.open(
        GITHUB_API_URL % github,
        http_basic_authentication: auth) { |o|
        JSON.parse(o.read, object_class: JSON::GenericObject)
      }
      if max_version = releases.map { |r|
        tag = r.tag_name
        if tag =~ /\A\d+\.\d+\.\d+\z/
          begin
            [ Version.new(tag), r ]
          rescue ArgumentError
          end
        end
      }.compact.max_by(&:first)
      then
        @version, @release = max_version
      end
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

    # The github reader method provides access to the github attribute that was
    # set during object initialization.
    #
    # This method returns the value of the github instance variable, which
    # typically represents the GitHub repository identifier in the format
    # "owner/repo" associated with the object.
    #
    # @return [ String ] the github value stored in the instance variable
    attr_reader :github

    # The auth reader method provides access to the auth attribute that was set
    # during object initialization.
    #
    # This method returns the value of the auth instance variable, which
    # typically represents authentication credentials used for accessing
    # protected resources or services.
    #
    # @return [ Array<String>, nil ] the auth value stored in the instance variable, or nil if not set
    attr_reader :auth

    # The download_asset method retrieves a compressed asset file from a GitHub
    # release by finding the appropriate asset based on a suffix filter and
    # downloading its contents
    # as binary data
    #
    # @return [ Array<String, String>, nil ] returns an array containing the asset filename
    #   and downloaded data if successful, or nil if no suitable asset is found or
    #   if there is no release information available
    def download_asset
      @release or return
      asset = @release.assets.find { |a| a.name =~ /#@suffix.*\.(zip|tar\.gz)\z/i } or return
      data = URI.open(
        (GITHUB_API_URL % github) + ("/assets/%s" % asset.id),
        'Accept' => 'application/octet-stream',
        http_basic_authentication: auth,
        &:read
      )
      return asset.name, data
    end

    # The inspect method returns a string representation of the object that
    # includes its class name and string value
    #
    # @return [ String ] a formatted string containing the object's class name
    #   and its string representation
    def inspect
      "#<#{self.class}: #{to_s}>"
    end

    # The to_s method returns a string representation of the object in the
    # format "name version".
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
    # @return [ String ] a formatted string containing the name and version
    #   separated by a space
    def to_s
      "#{name} #{version}"
    end
  end
end
