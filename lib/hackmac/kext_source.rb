require 'open-uri'
require 'json'
require 'tins/string_version'

module Hackmac
  class KextSource
    GITHUB_API_URL = 'https://api.github.com/repos/%s/releases'

    include Tins::StringVersion

    def initialize(github, auth: nil)
      account, repo = github.split(?/)
      @name = repo
      releases = URI.open(
        GITHUB_API_URL % github,
        http_basic_authentication: auth) { |o|
        JSON.parse(o.read, object_class: JSON::GenericObject)
      }
      if version = releases.map { |r|
          next unless r.tag_name.include?(?.)
          version = r.tag_name.delete '^.0-9'
          begin
            Version.new(version)
          rescue ArgumentError
          end
        }.compact.max
      then
        @version = version
      end
    end

    attr_reader :name

    attr_reader :version

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
