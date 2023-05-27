require 'term/ansicolor'
require 'tins'

class Hackmac::Graph
  include Term::ANSIColor

  include\
  module Formatters
    def as_bytes(value)
      Tins::Unit.format(value, prefix: :uc, format: '%.3f%U', unit: 'B')
    end

    def as_hertz(value)
      Tins::Unit.format(value, prefix: :uc, format: '%.3f%U', unit: 'Hz')
    end

    def as_celsius(value)
      "#{value}°"
    end

    def as_percent(value)
      "#{value}%"
    end

    def as_default(value)
      value.to_s
    end

    self
  end

  def initialize(title:, value: -> i { 0 }, format_value: nil, sleep: nil, color: nil)
    @title        = title
    @value        = value
    @format_value = format_value
    @sleep        = sleep
    @continue     = false
    @data         = []
    @color        = color
  end

  def start
    install_handlers
    full_reset
    perform hide_cursor
    @continue = true
    start_loop
  end

  def stop
    full_reset
    @continue = false
  end

  private

  def start_loop
    full_reset
    color       = pick_color
    color_light = color.to_rgb_triple.to_hsl_triple.lighten(15) rescue color
    i           = 0
    while @continue
      @lines, @cols = winsize

      @data << @value.(i)
      @data = data.last(cols)

      y_width = (data.max - data.min).to_f
      if y_width == 0
        perform(
          clear_screen,
          as_title("#@title / #{sleep_duration}"),
          move_to(lines / 2, (cols - "no data".size) / 2) { italic{"no data"} }
        )
        maybe_sleep
        next
      end

      perform clear_screen
      data.each_with_index do |value, x|
        x = x + cols - data.size + 1
        y = lines - (((value - data.min) * lines / y_width)).round + 1
        y.upto(lines) do |iy|
          perform move_to(iy, x) { on_color(y == iy ? color : color_light){' '} }
        end
      end

      perform(
        as_title("#@title #{format_value(data.last)} / #{sleep_duration}"),
        move_home { format_value(data.max).bold },
        move_to_line(lines) { format_value(data.min).bold }
      )

      maybe_sleep
    end
    full_reset
  rescue *[ Interrupt, defined?(IRB::Abort) && IRB::Abort ].compact
    stop
  end

  def perform(*a)
    print *a
  end

  attr_reader :cols

  attr_reader :lines

  attr_reader :data

  def as_title(text)
    move_to(lines, (cols - text.size) / 2) { bold{text} }
  end

  def sleep_duration
    @sleep ? "#{@sleep}s" : "once"
  end

  def format_value(value)
    case @format_value
    when Proc
      @format_value.(value)
    when Symbol
      send(@format_value, value)
    else
      send(:as_default, value)
    end
  end

  def pick_color
    Term::ANSIColor::Attribute[
      case @color
      when Proc
        @color.(@title)
      when nil
        cs = (21..226).select { |d|
          Term::ANSIColor::Attribute[d].to_rgb_triple.to_hsl_triple.
            lightness < 40
        }
        cs[ @title.bytes.reduce(0, :+) % cs.size ]
      else
        @color
      end
    ]
  end

  def maybe_sleep
    if @sleep
      sleep @sleep
    else
      @continue = false
    end
  end

  def normalize_value(value)
    case value
    when Float
      value
    else
      value.to_i
    end
  end

  def full_reset
    perform reset, clear_screen, move_home, show_cursor
  end

  def winsize
    Tins::Terminal.winsize
  end

  def install_handlers
    at_exit { full_reset }

    trap(:SIGWINCH) {
      lines, cols = winsize
      perform clear_screen,
        move_to(lines / 2, (cols - "Zzz…".size) / 2) { "Zzz…".italic }
    }
  end
end
