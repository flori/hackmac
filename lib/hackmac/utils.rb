require 'term/ansicolor'
class String
  include Term::ANSIColor
end
require 'tabulo'
require 'fileutils'
require 'tmpdir'
require 'shellwords'
require 'infobar'

module Hackmac
  module Utils
    include FileUtils

    def x(cmd, verbose: true, busy: nil)
      prompt = cmd =~ /\A\s*sudo/ ? ?# : ?$
      cmd_output = "#{prompt} #{cmd}".color(27) + (verbose ? "" : " >/dev/null".yellow)
      output, result = nil, nil
      if busy
        infobar.busy(label: busy) {
          infobar.puts cmd_output
          output = `#{cmd} 2>&1`
          result = $?
        }
      else
        infobar.puts cmd_output
        output = `#{cmd} 2>&1`
        result = $?
      end
      if verbose
        infobar.puts output.italic
      end
      if result.success?
        infobar.puts "✅ Command succeded!".green
      else
        infobar.puts "⚠️  Command #{cmd.inspect} failed with exit status #{result.exitstatus}".on_red.white
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
