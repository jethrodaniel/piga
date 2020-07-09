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
class Piga::Grammar::Lexer
# macros are just placeholders for match expressions
macro

  BLANK         [\ \t]+
  NEWLINE       [\n]
  # WORD          [a-zA-Z0-9_]+([a-zA-Z0-9_:][^\s]+)*
  WORD          [a-zA-Z0-9_:]+
  WORD_START    [a-zA-Z0-9_]+
  BLOCK         \{(?>[^{}]+|\g<0>)*\} # https://stackoverflow.com/a/35271017/7132678
  DOUBLE_QUOTE_STR "[^"]*" # "
  SINGLE_QUOTE_STR '[^']*' $ '
  # RANGE         \[.*\]

# note: lowercase states are inclusive, uppercase states are exclusive
rule
# state    match              action
           \#[^\n]*[\n]*      { t(:COMMENT, text) }
           {NEWLINE}          {
                                @line += 1
                                @column = 1
                                t(:LIT, text)
                              }
           ;                  { self.state = nil; t(:SEMI, text) }
           %{WORD}            { self.state = :dir; t(:DIRECTIVE, text) }
           {RANGE}            { t(:RANGE, text[1...-1]) }
           {BLOCK}            { t(:BLOCK, text) }
 :dir      {WORD}             { t(:NAME, text) }
           {WORD_START}       { t(:NAME, text) }
           :                  { t(:COLON, text) }
           {BLANK}            { t(:SPACE, text) }
           \+                 { t(:LIT, text) }
           \*                 { t(:LIT, text) }
           \|                 { t(:PIPE, text) }
           {DOUBLE_QUOTE_STR} { t(:LIT, text[1...-1]) }
           {SINGLE_QUOTE_STR} { t(:LIT, text[1...-1]) }
           # \(                 { t(:LEFT_PAREN, text) }
           # \)                 { t(:RIGHT_PAREN, text) }
           # !                  { t(:BANG, text) }

inner
  attr_reader :line, :column

  # @param code [String] input to be tokenized
  def tokenize code
    scan_setup code
    tokens = []
    while token = next_token
      tokens << token
    end
    tokens
  end
end

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
