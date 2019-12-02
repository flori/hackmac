require 'plist'
require 'shellwords'

module Hackmac
  module Plist
    def plist(*cmd)
      @plist = ::Plist.parse_xml(`#{Shellwords.join(cmd)}`)
    end

    def as_hash(*)
      @plist.dup
    end

    def to_json(*a)
      as_hash.to_json(*a)
    end
  end
end
