module Hackmac
  # A module that provides utility methods for creating temporary directories
  # and decompressing files.
  #
  # The AssetTools module offers helper methods designed to simplify common
  # tasks when working with temporary file operations and compressed assets. It
  # includes functionality for isolating code execution within temporary
  # directories and extracting various compressed file formats.
  #
  # @example
  #   include Hackmac::AssetTools
  #
  #   isolate do |dir|
  #     # Code executed within temporary directory
  #   end
  #
  #   decompress('archive.tar.gz')
  module AssetTools
    private

    # The isolate method creates a temporary directory and yields control to a
    # block within that directory context.
    #
    # This method establishes a temporary working directory using Dir.mktmpdir,
    # changes the current working directory to that location, and then executes
    # the provided block within that context. After the block completes, it
    # ensures proper cleanup of the temporary directory.
    #
    # @param block [ Block ] the block to execute within the temporary
    # directory context
    #
    # @return [ Object ] the return value of the yielded block
    def isolate
      Dir.mktmpdir do |dir|
        cd dir do
          yield dir
        end
      end
    end

    # The decompress method extracts compressed files in either ZIP or tar.gz
    # format
    #
    # This method takes a filename and attempts to decompress it using the
    # appropriate system command based on the file extension. It provides
    # visual feedback during the decompression process and raises an error if
    # the operation fails.
    #
    # @param name [ String ] the path to the compressed file to be decompressed
    #
    # @return [ void ] Returns nothing, but performs system decompression operations
    #
    # @raise [ RuntimeError ] raised when the file extension is not supported or
    #                         decompression commands fail
    def decompress(name)
      print "Decompressing #{name.inspect}…"
      case name
      when /\.zip\z/i
        system "unzip #{name.inspect}" or fail "Could not unzip #{name.inspect}"
      when /\.tar\.gz\z/i
        system "tar xfz #{name.inspect}" or fail "Could not tar xfz #{name.inspect}"
      else
        fail "Cannot decompress #{name.inspect}"
      end
      puts "done!"
    end
  end
end
