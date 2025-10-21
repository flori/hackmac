require 'complex_config/shortcuts'
require 'tins/xt/secure_write'
require 'fileutils'
require 'pathname'
require 'term/ansicolor'

module Hackmac
  # A module that provides configuration loading and management functionality
  # for Hackmac
  #
  # The Config module handles the initialization and retrieval of Hackmac's
  # configuration settings from specified files or default locations. It
  # manages configuration directories, creates default configuration files when
  # needed, and loads configurations into memory for use throughout the
  # application.
  #
  # @example
  #   Hackmac::Config.load
  #   # Loads the default configuration file
  #
  # @example
  #   Hackmac::Config.load(path: '/custom/config/path.yml')
  #   # Loads a custom configuration file from the specified path
  module Config
    extend FileUtils
    extend ComplexConfig::Provider::Shortcuts
    extend Term::ANSIColor

    # The default configuration settings for Hackmac application.
    DEFAULT = File.read(File.join(File.dirname(__FILE__), 'hackmac.yml'))

    # Loads the Hackmac configuration from the specified path or default
    # location
    #
    # This method initializes the configuration system by reading from a
    # specified file path or using the default configuration file location. It
    # ensures the configuration directory exists, sets up the configuration
    # provider's directory, creates a default configuration file if one doesn't
    # exist, and loads the configuration into memory for use throughout the
    # application.
    #
    # @param path [ String ] the file path to load the configuration from, defaults
    #   to the value of the HACKMAC_CONFIG environment variable or the default
    #   location ~/.config/hackmac/hackmac.yml
    #
    # @return [ ComplexConfig::Provider ] the loaded configuration provider object
    #   that can be used to access configuration values
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
