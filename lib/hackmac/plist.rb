require 'plist'
require 'shellwords'

module Hackmac
  # A module that provides methods for parsing and interacting with Property
  # List (plist) data
  #
  # The Plist module offers functionality to parse XML-formatted plist data
  # from shell commands and provides convenient access to the resulting hash
  # structure. It includes methods for executing commands, parsing their XML
  # output, and accessing plist values through dynamic method calls.
  #
  # @example
  #   class MyClass
  #     include Hackmac::Plist
  #   end
  #
  #   obj = MyClass.new
  #   obj.plist('diskutil', 'info', '-plist', '/dev/disk0')
  #   # Access parsed data through method_missing or as_hash
  module Plist
    # Parses XML output from a command into a plist hash
    #
    # This method executes a shell command and parses its XML output into a
    # Ruby hash using the Plist library. The resulting hash is stored in the
    # \@plist instance variable for later access through other methods.
    #
    # @param cmd [Array<String>] command and arguments to execute
    def plist(*cmd)
      @plist = ::Plist.parse_xml(`#{Shellwords.join(cmd)}`)
    end

    # The exist? method checks whether plist data has been loaded
    #
    # This method returns a truthy value if plist data has been successfully
    # parsed and stored in the instance variable, or nil if no plist data is
    # available.
    #
    # @return [ Object, nil ] returns the plist data if present, nil otherwise
    def exist?
      @plist
    end

    # Returns a duplicate of the internal plist hash
    #
    # This method provides access to the parsed plist data by returning a shallow copy
    # of the internal @plist instance variable. This allows external code to read
    # the plist contents without directly modifying the original data structure.
    #
    # @return [ Hash ] a duplicate of the plist hash containing the parsed XML data
    def as_hash(*a)
      @plist.dup.to_h
    end

    # The each method iterates over the parsed plist data
    #
    # This method provides an iterator interface for the plist hash by
    # delegating to the as_hash method's each implementation. It allows callers
    # to enumerate over the key-value pairs in the parsed plist structure.
    #
    # @yield [ key, value ] yields each key-value pair from the plist
    #
    # @return [ Hash ] returns the hash representation of the plist.
    def each(&block)
      as_hash.each(&block)
    end

    # The to_json method converts the parsed plist data to a JSON string
    #
    # This method takes the internal plist hash and serializes it into a JSON
    # format using the standard to_json method from the Hash class. It provides
    # a convenient way to output the plist data in JSON representation.
    #
    # @param a [ Array ] additional arguments to pass to the underlying to_json method
    #
    # @return [ String ] a JSON string representation of the plist data
    def to_json(*a)
      as_hash.to_json(*a)
    end

    # The method_missing method provides dynamic access to plist data by
    # handling attribute reads and writes through method calls
    #
    # This method intercepts undefined method calls on objects that include the
    # Plist module, allowing convenient access to plist values using
    # method-style syntax. When a method name ends with an equals sign, it sets
    # the corresponding plist key to the provided value. Otherwise, if the
    # method name matches an existing plist key, it returns the value.
    #
    # @param name [ Symbol ] the method name being called
    # @param a [ Array ] the arguments passed to the method
    #
    # @return [ Object ] the value of the plist key when reading, or nil when setting
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
