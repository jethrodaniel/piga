#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.7
# from lexical definition file "lib/piga/lexer.rex".
#++

require 'racc/parser'
# vim: set ft=ruby:

require "reline"

module Piga
  class Token
    attr_accessor :type, :value, :line, :column

    def initialize type, value, line = nil, column = nil
      @type   = type
      @value  = value || "" # so we can `+=` characters to this
      @line   = line
      @column = column
    end

    def to_s
      lexeme_end = @value.size.zero? ? @column : @column + @value&.size - 1
      value = if @type == :EOF
                # RUBY_ENGINE.include?("mruby") ? '"\x00"' : '"\\u0000"'
                '"\\u0000"'
              else
                @value.inspect
              end
      "[#{@line}:#{@column}-#{lexeme_end}][#{@type}, #{value}]"
    end

    def == other
      other.is_a?(Piga::Token) \
        && @line == other.line \
        && @column == other.column \
        && @value == other.value \
        && @type == other.type
    end
  end
end

module Piga
  module Grammar
    class Lexer < Racc::Parser
      attr_reader :line, :column
      def t type, value
        @line ||= 1
        @column ||= 1
        Piga::Token.new type, value, @line, @column
      end
    end
  end
end

# Piga's lexer, uses rexical.
#
# See
#   - https://github.com/tenderlove/rexical/pull/120
#   - https://github.com/tenderlove/rexical/blob/master/DOCUMENTATION.en.rdoc
#
class Piga::Grammar::Lexer < Racc::Parser
      require 'strscan'

      class ScanError < StandardError ; end

      attr_reader   :lineno
      attr_reader   :filename
      attr_accessor :state

      def scan_setup(str)
        @ss = StringScanner.new(str)
        @lineno =  1
        @state  = nil
      end

      def action
        yield
      end

      def scan_str(str)
        scan_setup(str)
        do_parse
      end
      alias :scan :scan_str

      def load_file( filename )
        @filename = filename
        File.open(filename, "r") do |f|
          scan_setup(f.read)
        end
      end

      def scan_file( filename )
        load_file(filename)
        do_parse
      end


        def next_token
          return if @ss.eos?

          # skips empty actions
          until token = _next_token or @ss.eos?; end
          token
        end

        def _next_token
          text = @ss.peek(1)
          @lineno  +=  1  if text == "\n"
          token = case @state
            when nil, :dir
          case
                  when (text = @ss.scan(/\#[^\n]*[\n]*/))
                     action { t(:COMMENT, text) }

                  when (text = @ss.scan(/[\n]+/))
                     action {
                                @line += 1
                                @column = 1
                                t(:NEWLINE, text)
                              }


                  when (text = @ss.scan(/;/))
                     action { self.state = nil; t(:SEMI, text) }

                  when (text = @ss.scan(/%[a-zA-Z0-9_:]+/))
                     action { self.state = :dir; t(:DIRECTIVE, text) }

                  when (text = @ss.scan(/\{(?>[^{}]+|\g<0>)*\}/))
                     action { t(:BLOCK, text) }

                  when((state == :dir) and (text = @ss.scan(/[a-zA-Z0-9_:]+/)))
                     action { t(:NAME, text) }

                  when (text = @ss.scan(/[a-zA-Z0-9_]+/))
                     action { t(:NAME, text) }

                  when (text = @ss.scan(/:/))
                     action { t(:COLON, text) }

                  when (text = @ss.scan(/{BLANK}/))
                     action { t(:SPACE, text) }

                  when (text = @ss.scan(/\+/))
                     action { t(:PLUS, text) }

                  when (text = @ss.scan(/\*/))
                     action { t(:STAR, text) }

                  when (text = @ss.scan(/\|/))
                     action { t(:PIPE, text) }

                  when (text = @ss.scan(/"(?>[^"]+|\g<0>)*"/))
                     action { t(:DOUBLE_QUOTE_STR, text) }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

        else
          raise  ScanError, "undefined state: '" + state.to_s + "'"
        end  # case state
          token
        end  # def _next_token

  attr_reader :line, :column
  def tokenize code
    scan_setup code
    tokens = []
    while token = next_token
      tokens << token
    end
    tokens
  end
end # class

module Piga::Grammar
  class Lexer < ::Racc::Parser
    def self.interactive
      while line = Reline.readline("lexer> ", true)&.chomp
        case line
        when "q", "quit", "exit"
          puts "goodbye! <3"
          exit
        else
          begin
            lex = Piga::Grammar::Lexer.new
            lex.scan_setup line
            while token = lex.next_token
              puts token
            end
          rescue Piga::Grammar::Lexer::ScanError => e
            puts e.message
          end
        end
      end
    end

    def self.lex_file filename
      lex = Piga::Grammar::Lexer.new
      lex.load_file filename
      while token = lex.next_token
        p token
      end
    end

    # Lex each file passed as input, or run interactively
    def self.start args = ARGV
      return Piga::Grammar::Lexer.interactive if args.size.zero?

      args.each do |file|
        abort "#{file} is not a file!" unless File.file?(file)
        Piga::Grammar::Lexer.lex_file file
      end
    rescue Piga::Grammar::Lexer::ScanError => e
      abort e.message
    end
  end
end

if $0 == __FILE__
  case ARGV&.dig 0
  when "-i", "--interactive"
    Piga::Grammar::Lexer.interactive
  else
    lex = Piga::Grammar::Lexer.new ARGF.read
    puts lex.tokenize
  end
end
