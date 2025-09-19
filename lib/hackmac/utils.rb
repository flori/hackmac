require 'term/ansicolor'
class String
  include Term::ANSIColor
end
require 'tabulo'
require 'fileutils'
require 'tmpdir'
require 'shellwords'

module Hackmac
  # A module that provides utility methods for executing shell commands and
  # interacting with users.
  #
  # The Utils module includes methods for running system commands with colored
  # output, prompting users for input, and handling common file operations in a
  # Hackmac context.
  module Utils
    include FileUtils

    # The x method executes a shell command and displays its output with
    # colorized prompts.
    #
    # @param cmd [ String ] the shell command to execute
    # @param verbose [ TrueClass, FalseClass ] whether to show command output in verbose mode
    #
    # @return [ String ] the captured output of the command execution
    def x(cmd, verbose: true)
      prompt = cmd =~ /\A\s*sudo/ ? ?# : ?$
      cmd_output = "#{prompt} #{cmd}".color(27) + (verbose ? "" : " >/dev/null".yellow)
      output, result = nil, nil
      puts cmd_output
      system "#{cmd} 2>&1"
      result = $?
      if result.success?
        puts "✅ Command succeded!".green
      else
        puts "⚠️  Command #{cmd.inspect} failed with exit status #{result.exitstatus}".on_red.white
        exit result.exitstatus
      end
      output
    end

    # The ask method prompts the user for a yes/no response.
    #
    # @param prompt [ String ] the message to display to the user
    # @return [ Boolean ] true if the user answered 'y' or 'Y', false otherwise
    def ask(prompt)
      print prompt.bold.yellow
      gets =~ /\Ay/i
    end
  end
end
