require 'open-uri'
require 'json'
require 'tins/string_version'

module Hackmac
  class KextSource
    GITHUB_API_URL = 'https://api.github.com/repos/%s/releases'

    include Tins::StringVersion

    def initialize(github, auth: nil)
      @github = github
      @auth   = auth
      account, repo = github.split(?/)
      @name = repo
      releases = URI.open(
        GITHUB_API_URL % github,
        http_basic_authentication: auth) { |o|
        JSON.parse(o.read, object_class: JSON::GenericObject)
      }
      if max_version = releases.map { |r|
          next unless r.tag_name.include?(?.)
          tag = r.tag_name.delete '^.0-9'
          begin
            [ Version.new(tag), r ]
          rescue ArgumentError
          end
        }.compact.max_by(&:first)
      then
        @version, @release = max_version
      end
    end

    attr_reader :name

    attr_reader :version

    attr_reader :github

    attr_reader :auth

    def download_asset
      @release or return
      asset = @release.assets.find { |a| a.name =~ /RELEASE.*zip/ } or return
      data = URI.open(
        (GITHUB_API_URL % github) + ("/assets/%s" % asset.id),
        'Accept' => 'application/octet-stream',
        http_basic_authentication: auth
      ) { |o| o.read }
      return asset.name, data
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
