class Hackmac::Graph
  class Display
    ANSI = Term::ANSIColor

    class Cell < Struct.new(:char, :color, :on_color, :styles)
      def ==(other)
        to_a == other.to_a
      end

      def to_s
        result = ''
        result << ANSI.color(color)
        result << ANSI.on_color(on_color)
        styles.each { |s| result << ANSI.send(s) }
        result << char
        result << ANSI.reset
      end
    end

    def initialize(lines, columns)
      @lines_range   = 1..lines
      @columns_range = 1..columns
      clear
    end

    def clear
      @x        = 1
      @y        = 1
      @color    = 15
      @on_color = 0
      @styles   = []
      @cells    =
        Array.new(lines) {
          Array.new(columns) {
            Cell.new(' ', @color, @on_color, @styles)
          }
        }
      reset
    end

    def reset
      @color    = 15
      @on_color = 0
      @styles   = []
      self
    end

    def each(&block)
      Enumerator.new do |enum|
        @lines_range.each do |y|
          @columns_range.each do |x|
            enum.yield y, x, @cells[y - 1][x - 1]
          end
        end
      end.each(&block)
    end

    def -(old)
      dimensions != old.dimensions and raise ArgumentError,
        "old dimensions #{old.dimensions.inspect} don't match #{dimensions.inspect}"
      result = ''
      each.zip(old.each) do |(my, mx, me), (_, _, old)|
        if me != old
          result << ANSI.move_to(my, mx) << me.to_s
        end
      end
      result
    end

    def to_s
      each.inject(ANSI.clear_screen)  do |s, (y, x, c)|
        s << ANSI.move_to(y, x) << c.to_s
      end
    end

    def inspect
      "#<#{self.class}: #{columns}×#{lines}>"
    end

    attr_reader :x

    attr_reader :y

    def lines
      @lines_range.end
    end

    def columns
      @columns_range.end
    end

    def dimensions
      [ lines, columns ]
    end

    def styled(*s)
      if nope = s.find { !style?(_1) }
        raise ArgumentError, "#{nope} is not a style"
      end
      @styles = s
      self
    end

    def at(y, x)
      @lines_range.include?(y) or
        raise ArgumentError, "y #{y} out of lines range #@lines_range"
      @columns_range.include?(x) or
        raise ArgumentError, "x #{x} out of columns range #@columns_range"
      @y, @x = y, x
      self
    end

    def put(char)
      char.size == 1 or
        raise ArgumentError, "#{char} is not single character"
      @cells[@y - 1][@x - 1] = Cell.new(char, @color, @on_color, @styles)
      self
    end

    def write(string)
      string.each_char do |char|
        put(char)
        if x < columns - 1
          at(y, x + 1)
        else
          break
        end
      end
      self
    end

    def top
      at(1, x)
    end

    def bottom
      at(lines, x)
    end

    def left
      at(y, 1)
    end

    def right
      at(y, columns)
    end

    def centered
      at(lines / 2, columns / 2)
    end

    def write_centered(string)
      at(@y, (columns - string.size) / 2).write(string)
    end

    def get
      @cells[@y - 1][@x - 1]
    end

    def color(color)
      @color = attribute!(color)
      self
    end

    def on_color(on_color)
      @on_color = attribute!(on_color)
      self
    end

    private

    def style?(s)
      [
        :bold,
        :dark,
        :faint,
        :italic,
        :underline,
        :underscore,
        :blink,
        :rapid_blink,
        :reverse,
        :negative,
        :concealed,
        :conceal,
        :strikethrough,
      ].member?(s)
    end

    def attribute?(a)
      Term::ANSIColor::Attribute[a]
    end

    def attribute!(a)
      attribute?(a) or
        raise ArgumentError, "#{a.inspect} is not a color attribute"
    end
  end
end
