require 'hackmac/plist'
require 'pathname'

module Hackmac
  class Kext
    include Hackmac::Plist

    def initialize(path:)
      @path = Pathname.new(path) + 'Contents/Info.plist'
      @plist = File.open(@path, encoding: 'UTF-8') { |f| ::Plist.parse_xml(f) }
    end

    def identifier
      as_hash['CFBundleIdentifier']
    end

    def name
      as_hash['CFBundleName'] || File.basename(identifier)
    end

    def version
      as_hash['CFBundleShortVersionString']
    end

    def inspect
      "#<#{self.class}: #{to_s}>"
    end

    def to_s
      "#{name} #{version}"
    end

    def find_matches(others)
      candidates = others.select { |o| o.name == name }
      candidates.group_by { |c| c.version == version }
    end

    def compare_to(others)
      matches = find_matches others
      if other = matches[false]&.first
        "#{to_s.red} ⚡#{other.to_s.red}"
      elsif other = matches[true]&.first
        "#{to_s.green} = #{other.to_s.green}"
      else
        "#{to_s.yellow}"
      end
    end
  end
end
