require 'hashie'

module Hackmac
  # A class that provides access to IORegistry information through plist
  # parsing
  #
  # The IOReg class interfaces with macOS's IORegistry system to retrieve and
  # parse hardware-related information for a specified key. It executes the
  # ioreg command with appropriate flags to fetch XML data, processes this data
  # into a structured hash format, and makes it available for querying through
  # dynamic method calls.
  #
  # @example
  #   ioreg = Hackmac::IOReg.new(key: 'IOPowerManagement')
  #   # Provides access to power management information through method calls
  class IOReg
    include Hackmac::Plist
    # The initialize method sets up an IOReg instance by executing a system
    # command to retrieve hardware registry information for a specific key.
    #
    # This method constructs and runs a shell command using the ioreg utility
    # to fetch detailed information about a specified hardware key from the
    # IOService registry. It processes the XML output, extends the resulting
    # hash with deep find capabilities, and stores the largest matching result
    # set in the instance variable.
    #
    # @param key [ String ] the hardware registry key to search for in the
    #   IOService tree
    def initialize(key:)
      plist(*(%w[ioreg -a -p IOService -r -k ] << key))
      if @plist
        @plist.extend Hashie::Extensions::DeepFind
        @plist = @plist.deep_find_all(key).max_by(&:size)
      end
    end
  end
end
