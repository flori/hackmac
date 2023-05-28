require 'hashie'

module Hackmac
  class IOReg
    include Hackmac::Plist

    def initialize(key:)
      plist *(%w[ioreg -a -p IOService -r -k ] << key)
      @plist.extend Hashie::Extensions::DeepFind
      @plist = @plist.deep_find_all(key).max_by(&:size)
    end
  end
end
