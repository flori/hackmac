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

  def initialize(
    title:,
    value: -> i { 0 },
    format_value: nil,
    sleep: nil,
    color: nil
  )
    sleep >= 0 or raise ArgumentError, 'sleep has to be >= 0'
    @title        = title
    @value        = value
    @format_value = format_value
    @sleep        = sleep
    @continue     = false
    @data         = []
    @color        = color
    @mutex        = Mutex.new
  end

  def start
    install_handlers
    full_reset
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
    @counter    = -1
    @continue = true
    while @continue
      @start = Time.now
      @full_reset and full_reset
      perform hide_cursor

      @data << @value.(@counter += 1)
      @data = data.last(columns)

      y_width = (data.max - data.min).to_f
      if y_width == 0
        @display.reset.bottom.styled(:bold).
          write_centered("#@title / #{sleep_duration}").
          reset.centered.styled(:italic).write_centered("no data")
        perform_display_diff
        sleep_now
        next
      end

      @display.reset
      data.each_with_index do |value, x|
        x = x + columns - data.size + 1
        y = lines - (((value - data.min) * lines / y_width)).round + 1
        y.upto(lines) do |iy|
          @display.at(iy, x).on_color(
            y == iy ? color : color_light
          ).write(' ')
        end
      end

      @display.reset.bottom.styled(:bold).
        write_centered("#@title #{format_value(data.last)} / #{sleep_duration}")
      @display.reset.styled(:bold).
        left.top.write(format_value(data.max)).
        left.bottom.write(format_value(data.min))

      perform_display_diff
      sleep_now
    end
  rescue Interrupt
  ensure
    stop
  end

  def perform(*a)
    print *a
  end

  def columns
    @display.columns
  end

  def lines
    @display.lines
  end

  attr_reader :data

  def sleep_duration
    "#{@sleep}s"
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

  def sleep_now
    duration = if @start
                 [ @sleep - (Time.now - @start).to_f, 0 ].max
               else
                 @sleep
               end
    sleep duration
  end

  def perform_display_diff
    @mutex.synchronize do
      unless @old_display && @old_display.dimensions == @display.dimensions
        @old_display = @display.dup.clear
      end
      diff = @display - @old_display
      if ENV['DEBUG_BYTESIZE']
        unless @last
          STDERR.puts %w[ size duration ] * ?\t
        else
          STDERR.puts [ diff.size, (Time.now - @last).to_f ] * ?\t
        end
        @last = Time.now
      end
      perform diff
      @display, @old_display = @old_display.clear, @display
      perform move_to(lines, columns)
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
    @mutex.synchronize do
      perform reset, clear_screen, move_home, show_cursor
      winsize = Tins::Terminal.winsize
      @display     = Hackmac::Graph::Display.new(*winsize)
      @old_display = Hackmac::Graph::Display.new(*winsize)
      perform @display
      @full_reset = false
    end
  end

  def install_handlers
    at_exit { full_reset }
    trap(:SIGWINCH) do
      @full_reset = true
      perform reset, clear_screen, move_home, 'Zzz…'
    end
  end
end

require 'hackmac/graph/display'
