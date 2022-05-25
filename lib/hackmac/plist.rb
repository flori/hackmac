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

    def each(&block)
      as_hash.each(&block)
    end

    def to_json(*a)
      as_hash.to_json(*a)
    end

    def method_missing(name, *a)
      n = name.to_s
      if n =~ /(.+)=\z/
        @plist[$1] = a.first
      elsif @plist.key?(n)
        @plist[n]
      end
    end
  end
end
