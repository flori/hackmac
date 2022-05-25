module Hackmac
  class OC
    def initialize(config:)
      @config = config
    end

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

    def name
      remote.name
    end

    def version
      remote.version
    end

    def inspect
      "#<#{self.class}: #{to_s}>"
    end

    def to_s
      "#{name} #{version}"
    end
  end
end

