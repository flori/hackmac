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
      output = `#{cmd} 2>&1`
      if $?.success?
        print "#{prompt} #{cmd}".green
        puts verbose ? "" : " >/dev/null".yellow
      else
        print "#{prompt} #{cmd}".red
        puts verbose ? "" : " >/dev/null".yellow
        STDERR.puts "command #{cmd.inspect} failed with exit status #{$?.exitstatus}".on_red.white
      end
      if verbose
        print output.italic
      end
      output
    end

    def ask(prompt)
      print prompt.bold.yellow
      gets =~ /\Ay/i
    end
  end
end
