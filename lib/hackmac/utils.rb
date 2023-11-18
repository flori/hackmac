require 'term/ansicolor'
class String
  include Term::ANSIColor
end
require 'tabulo'
require 'fileutils'
require 'tmpdir'
require 'shellwords'

module Hackmac
  module Utils
    include FileUtils

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

    def ask(prompt)
      print prompt.bold.yellow
      gets =~ /\Ay/i
    end
  end
end
