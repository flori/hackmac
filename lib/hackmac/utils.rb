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
      print "#{prompt} #{cmd}".color(27)
      puts verbose ? "" : " >/dev/null".yellow
      output = `#{cmd} 2>&1`
      if $?.success?
        puts "✅ Command succeded!".green
      else
        puts "⚠️  Command #{cmd.inspect} failed with exit status #{$?.exitstatus}".on_red.white
        exit $?.exitstatus
      end
      if verbose
        puts output.italic
      end
      output
    end

    def ask(prompt)
      print prompt.bold.yellow
      gets =~ /\Ay/i
    end
  end
end
