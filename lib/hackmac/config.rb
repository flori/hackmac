require 'complex_config/shortcuts'
require 'tins/xt/secure_write'
require 'fileutils'
require 'pathname'
require 'term/ansicolor'

module Hackmac
  module Config
    extend FileUtils
    extend ComplexConfig::Provider::Shortcuts
    extend Term::ANSIColor

    DEFAULT = File.read(File.join(File.dirname(__FILE__), 'hackmac.yml'))

    def self.load(path: ENV.fetch('HACKMAC_CONFIG', '~/.config/hackmac/hackmac.yml'))
      path = Pathname.new(path).expand_path
      mkdir_p path.dirname
      ComplexConfig::Provider.config_dir = path.dirname
      unless path.exist?
        File.secure_write(path.to_s, DEFAULT)
      end
      puts "Loading config from #{color(33) { path.to_s.inspect} }."
      ComplexConfig::Provider[path.basename.to_s.sub(/\..*?\z/, '')]
    end
  end
end
