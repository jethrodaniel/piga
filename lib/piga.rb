#!/usr/bin/env ruby
# frozen_string_literal: true

# Simple PEG generator

module Piga
  # A minimal `StringScanner` that keeps track of line and column numbers
  #
  # TODO: move line hanfling out into grammar/lexer grammar
  class Scanner
    attr_reader :line, :column, :string
    attr_accessor :pos

    def initialize string
      @string = string
      @pos = 0
      @line = 1
      @column = 1
      @last_column = 1
      @last_line = 1
      @newlines = {} # 0..12 => q
    end

    # @note advances the scanner head
    # @return [String] the next character, EOF char if at the end of input
    def advance
      raise "pos is less than zero (#{@pos})" if @pos.negative?

      c = @string[@pos]
      @pos += 1

      if c == "\n"
        @newlines[@last_column - 1..@pos] = @line
        @last_line = @line
        @last_column = @column
        @line += 1
        @column = 1
      else
        @column += 1
      end

      c || "\0"
    end

    def backup
      if current_char == "\n"
        @line -= 1
        @column = @last_column
      else
        @column -= 1
      end
      @pos -= 1
      current_char
    end

    # @param nth [Integer]
    # @return [String] nth character past the scanner head
    def peek nth = 1
      start = @pos + 1
      c = @string[start...start + nth]
      c.nil? || c.empty? ? "\0" : c
    end

    # @return [Boolean]
    def eof?
      current_char == "\0"
    end

    # @return [String] the character under the scanner head, or EOF if at end
    def current_char
      @string[@pos] || "\0"
    end

    def match? str
      case str.size
      when 1
        advance if current_char == str
      else
        match = "#{current_char}#{peek(str.size - 1)}"
        if match == str
          str.size.times { str << advance }
          match
        end
      end
    end

    # def reset pos
    #   raise "pos is less than zero (#{pos})" if pos.negative?
    #   raise "pos (#{pos}) exceeds source length (#{@string.size})" if pos > @string.size - 1

    #   @pos = pos

    #   @line = @newlines[pos]
    #   @column = pos - @line

    #   current_char
    # end
  end
end

module Piga
  class Parser
    attr_reader :scanner

    def initialize str
      @scanner = Scanner.new str
    end

    def error msg
      puts msg
      abort
    end

    def pos
      @scanner.pos
    end

    def reset index
      @scanner.pos = index
    end

    def consume *strs
      strs.each do |s|
        if match = @scanner.match?(s)
          return match
        end
      end
      nil
    end

    def consume_star *strs
      ret = []
      while s = consume(*strs)
        ret << s
      end
      ret
    end

    def consume_rule *rules
      rules.each do |r|
        unless respond_to?(r)
          error "rule `#{r}` is not defined in the grammar"
        end

        if match = send(r)
          return match
        end
      end
      nil
    end

    def skip_until *strs
      start = pos
      @scanner.advance until strs.include?(@scanner.current_char) || @scanner.eof?
      @scanner.string[start...pos]
    end

    def consume_star_rule *rules
      ret = []
      loop do
        rules.each do |r|
          res = send(r)
          return ret unless res

          ret << res
        end
      end
      ret
    end

    def consume_plus_rule *rules
      ret = []
      loop do
        rules.each do |r|
          res = send(r)
          return ret unless res

          ret << res
        end
      end
      ret unless ret.empty?
    end
  end
end

module Piga
  module Grammar
    class Parser < Piga::Parser
      def comment
        skip_until "\n" if consume "#"
      end

      def literal
        start = pos
        ["'", '"'].each do |quote|
          next unless @scanner.current_char == quote

          @scanner.advance
          ret = skip_until quote
          @scanner.advance
          return ret
        end
        nil
      end

      def name
        start = pos
        case @scanner.current_char
        when "a".."z", "A".."Z", "_"
          @scanner.advance
          loop do
            case @scanner.current_char
            when "a".."z", "A".."Z", "_"
              @scanner.advance
            when ":"
              if @scanner.peek == ":"
                2.times { @scanner.advance }
              else
                break
                # return nil
              end
            else
              break
            end
          end
        end
        start == pos ? nil : @scanner.string[start...pos]
      end

      def _directive
        if @scanner.current_char == "%"
          @scanner.advance
          if n = name
            return n
          end
        end
        nil
      end

      def block
        if @scanner.current_char == "{"
          @scanner.advance
          ret = skip_until "}"
          @scanner.advance
          return ret
        end
        nil
      end
    end
  end
end
