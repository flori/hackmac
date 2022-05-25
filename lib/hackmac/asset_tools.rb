module Hackmac
  module AssetTools
    private

    def isolate
      Dir.mktmpdir do |dir|
        cd dir do
          yield dir
        end
      end
    end

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
