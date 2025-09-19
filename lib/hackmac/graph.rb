require 'term/ansicolor'
require 'tins'
require 'digest/md5'

# A class that provides graphical display functionality for terminal-based data
# visualization
#
# The Graph class enables the creation of dynamic, real-time visualizations of
# data values within a terminal environment. It manages the rendering of
# graphical representations such as line charts or graphs, updating them
# continuously based on provided data sources. The class handles terminal
# control operations, including cursor positioning, color management, and
# screen clearing to ensure smooth visual updates. It also supports
# configuration of display parameters like title, formatting strategies for
# values, update intervals, and color schemes for different data series.
#
# @example
#   graph = Hackmac::Graph.new(
#     title: 'CPU Usage',
#     value: ->(i) { rand(100) },
#     format_value: :as_percent,
#     sleep: 1,
#     color: 33
#   )
#   graph.start
#   # Starts the graphical display loop
#
# @example
#   graph = Hackmac::Graph.new(
#     title: 'Memory Usage',
#     value: ->(i) { `vm_stat`.match(/Pages free: (\d+)/)[1].to_i },
#     format_value: :as_bytes,
#     sleep: 2
#   )
#   graph.start
#   # Starts a memory usage graph with custom data source and formatting
class Hackmac::Graph
  include Term::ANSIColor

  # A module that provides various formatting methods for converting numeric
  # values into human-readable strings with appropriate units and display
  # formats.
  #
  # The Formatters module contains a collection of utility methods designed to
  # transform raw numeric data into formatted strings that are more suitable
  # for display purposes. These methods handle common formatting tasks such as
  # converting byte measurements, frequency values, temperature readings, and
  # percentages into clean, readable representations.
  #
  # Each formatter method in this module is intended to be used with data
  # visualization or reporting scenarios where presenting numerical information
  # in an easily understandable format is important. The module also includes
  # specialized functionality for deriving consistent color values based on
  # input strings, which can be useful for maintaining visual coherence when
  # displaying multiple data series.
  #
  # @example
  #   include Hackmac::Graph::Formatters
  #
  #   as_bytes(1024 * 1024)        # => "1.000MB"
  #   as_hertz(2500000000)        # => "2.500GHz"
  #   as_celsius(37.5)            # => "37.5°"
  #   as_percent(95.7)            # => "95.7%"
  #   as_default(42)              # => "42"
  module Formatters
    # The as_bytes method formats a numeric value into a human-readable byte
    # representation
    #
    # This method takes a numeric input and converts it into a formatted string
    # representing the value in bytes with appropriate binary prefixes (KB,
    # MB, GB, etc.)
    #
    # @param value [ Numeric ] the numeric value to be formatted as bytes
    #
    # @return [ String ] the formatted byte representation with unit suffix
    def as_bytes(value)
      Tins::Unit.format(value, prefix: :uc, format: '%.3f%U', unit: 'B')
    end

    # The as_hertz method formats a numeric value into a human-readable
    # frequency representation
    #
    # This method takes a numeric input and converts it into a formatted string
    # representing the value in hertz with appropriate metric prefixes (kHz,
    # MHz, GHz, etc.)
    #
    # @param value [ Numeric ] the numeric frequency value to be formatted
    #
    # @return [ String ] the formatted frequency representation with unit suffix
    def as_hertz(value)
      Tins::Unit.format(value, prefix: :uc, format: '%.3f%U', unit: 'Hz')
    end

    # The as_celsius method formats a temperature value with a degree symbol
    #
    # This method takes a numeric temperature value and returns a string
    # representation with the degree Celsius symbol appended to it
    #
    # @param value [ Numeric ] the temperature value to be formatted
    #
    # @return [ String ] the temperature value formatted with a degree Celsius symbol
    def as_celsius(value)
      "#{value}°"
    end

    # The as_percent method formats a numeric value as a percentage string
    #
    # This method takes a numeric input and returns a string representation
    # with a percent sign appended to it, providing a simple way to format
    # numeric values as percentages for display purposes
    #
    # @param value [ Numeric ] the numeric value to be formatted as a percentage
    #
    # @return [ String ] the numeric value formatted as a percentage string
    def as_percent(value)
      "#{value}%"
    end

    # The as_default method converts a value to its string representation
    #
    # This method takes any input value and converts it to a string using the to_s method
    # It serves as a fallback formatting option when no specific formatting is required
    #
    # @param value [ Object ] the value to be converted to a string
    #
    # @return [ String ] the string representation of the input value
    def as_default(value)
      value.to_s
    end

    # The derive_color_from_string method calculates a color value based on the
    # input string by generating an MD5 hash and selecting from a predefined
    # set of dark colors
    #
    # @param string [ String ] the input string used to derive the color value
    #
    # @return [ Integer ] the derived color value from the set of dark ANSI attributes
    def derive_color_from_string(string)
      cs = (21..226).select { |d|
        Term::ANSIColor::Attribute[d].to_rgb_triple.to_hsl_triple.
          lightness < 40
      }
      s = Digest::MD5.digest(string).unpack('Q*')
      cs[ s.first % cs.size ]
    end

    self
  end
  include Formatters

  # The initialize method sets up a Graph instance by configuring its display
  # parameters and internal state
  #
  # This method configures the graph visualization with title, value provider,
  # formatting options, update interval, and color settings. It initializes
  # internal data structures for storing historical values and manages
  # synchronization through a mutex for thread-safe operations.
  #
  # @param title [ String ] the title to display at the bottom of the graph
  # @param value [ Proc ] a proc that takes an index and returns a numeric value for plotting
  # @param format_value [ Proc, Symbol, nil ] formatting strategy for displaying values
  # @param sleep [ Numeric ] time in seconds between updates
  # @param color [ Integer, Proc, nil ] color index or proc to determine color dynamically
  #
  # @raise [ ArgumentError ] if the sleep parameter is negative
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

  # The start method initiates the graphical display process by setting up
  # signal handlers, performing an initial terminal reset, and entering the
  # main update loop
  #
  # This method serves as the entry point for starting the graph visualization
  # functionality. It configures the necessary signal handlers for graceful
  # shutdown and terminal resizing, performs an initial full reset of the
  # display state, and then begins the continuous loop that updates and renders
  # graphical data.
  def start
    install_handlers
    full_reset
    start_loop
  end

  # The stop method terminates the graphical display process by performing a
  # full reset and setting the continue flag to false
  #
  # This method serves as the shutdown mechanism for the graph visualization
  # functionality. It ensures that all display resources are properly cleaned
  # up and the terminal state is restored to its original condition before
  # stopping the continuous update loop.
  def stop
    full_reset
    @continue = false
  end

  private

  # The start_loop method executes a continuous loop to update and display
  # graphical data
  #
  # This method manages the main execution loop for rendering graphical
  # representations of data values over time. It initializes display state,
  # processes incoming data, calculates visual representations, and handles
  # terminal updates while respecting configured timing intervals.
  #
  # It continuously updates the display and handles data processing in a loop
  # until explicitly stopped.
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
    print(*a)
  end

  # The columns method returns the number of columns in the display
  #
  # This method provides access to the horizontal dimension of the graphical
  # display by returning the total number of columns available for rendering
  # content
  #
  # @return [ Integer ] the number of columns (characters per line) in the display object
  def columns
    @display.columns
  end

  # The lines method returns the number of lines in the display
  #
  # This method provides access to the vertical dimension of the graphical
  # display by returning the total number of rows available for rendering
  # content
  #
  # @return [ Integer ] the number of lines (rows) in the display object
  def lines
    @display.lines
  end

  # The data reader method provides access to the data attribute that was set
  # during object initialization.
  #
  # This method returns the value of the data instance variable, which
  # typically contains structured information that has been processed or
  # collected by the object.
  #
  # @return [ Array<Object>, Hash, nil ] the data value stored in the instance variable, or nil if not set
  attr_reader :data

  # The sleep_duration method returns a string representation of the configured
  # sleep interval with the 's' suffix appended to indicate seconds.
  #
  # @return [ String ] a formatted string containing the sleep duration in seconds
  def sleep_duration
    "#{@sleep}s"
  end

  # The format_value method processes a given value using the configured
  # formatting strategy
  #
  # This method applies the appropriate formatting to a value based on the
  # \@format_value instance variable configuration It supports different
  # formatting approaches including custom Proc objects, Symbol-based method
  # calls, and default formatting
  #
  # @param value [ Object ] the value to be formatted according to the configured strategy
  #
  # @return [ String ] the formatted string representation of the input value
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

  # The pick_color method determines and returns an ANSI color attribute based
  # on the configured color setting
  #
  # This method evaluates the @color instance variable to decide how to select
  # a color attribute. If @color is a Proc, it invokes the proc with the @title
  # to determine the color. If @color is nil, it derives a color from the title
  # string. Otherwise, it uses the @color value directly as an index into the
  # ANSI color attributes.
  #
  # @return [ Term::ANSIColor::Attribute ] the selected color attribute object
  def pick_color
    Term::ANSIColor::Attribute[
      case @color
      when Proc
        @color.(@title)
      when nil
        derive_color_from_string(@title)
      else
        @color
      end
    ]
  end
  def pick_color
    Term::ANSIColor::Attribute[
      case @color
      when Proc
        @color.(@title)
      when nil
        derive_color_from_string(@title)
      else
        @color
      end
    ]
  end

  # The sleep_now method calculates and executes a sleep duration based on the
  # configured sleep time and elapsed time since start
  #
  # This method determines how long to sleep by calculating the difference
  # between the configured sleep interval and the time elapsed since the last
  # operation started. If no start time is recorded, it uses the full
  # configured sleep duration. The method ensures that negative sleep durations
  # are not used by taking the maximum of the calculated duration and zero.
  def sleep_now
    duration = if @start
                 [ @sleep - (Time.now - @start).to_f, 0 ].max
               else
                 @sleep
               end
    sleep duration
  end

  # The perform_display_diff method calculates and displays the difference
  # between the current and previous display states to update only the changed
  # portions of the terminal output
  #
  # This method synchronizes access to shared display resources using a mutex,
  # then compares the current display with the previous state to determine what
  # needs updating. It handles dimension mismatches by resetting the old
  # display, computes the visual difference, and outputs only the modified
  # portions to reduce terminal update overhead
  #
  # When the DEBUG_BYTESIZE environment variable is set, it also outputs
  # debugging information about the size of the diff and the time elapsed since
  # the last debug output
  #
  # @return [ void ] Returns nothing but performs terminal output operations
  #   and updates internal display state
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


  # The normalize_value method converts a value to its appropriate numeric
  # representation
  #
  # This method takes an input value and normalizes it to either a Float or
  # Integer type depending on its original form. If the value is already a
  # Float, it is returned as-is. For all other types, the method attempts to
  # convert the value to an integer using to_i
  #
  # @param value [ Object ] the value to be normalized
  #
  # @return [ Float, Integer ] the normalized numeric value as either a Float
  #   or Integer
  def normalize_value(value)
    case value
    when Float
      value
    else
      value.to_i
    end
  end

  # The full_reset method performs a complete reset of the display and terminal
  # state
  #
  # This method synchronizes access to shared resources using a mutex, then
  # executes a series of terminal control operations to reset the terminal
  # state, clear the screen, move the cursor to the home position, and make the
  # cursor visible. It also initializes new display objects with the current
  # terminal dimensions and updates the internal
  # display state.
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

  # The install_handlers method sets up signal handlers for graceful shutdown
  # and terminal resize handling
  #
  # This method configures two signal handlers: one for the exit hook that
  # performs a full reset, and another for the SIGWINCH signal that handles
  # terminal resize events by setting a flag and displaying a sleeping message
  def install_handlers
    at_exit { full_reset }
    trap(:SIGWINCH) do
      @full_reset = true
      perform reset, clear_screen, move_home, 'Zzz…'
    end
  end
end

require 'hackmac/graph/display'
