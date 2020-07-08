#!/usr/bin/env ruby
# frozen_string_literal: true

# Simple PEG generator

# lex/token.rb
# piga/token_stream.rb
module Piga
  class TokenStream
    attr_accessor :pos

    def initialize lexer
      @lexer = lexer
      @tokens = []
      @pos = 0
    end

    def peek
      if @pos == @tokens.size
        t = if @lexer
             @line = @lexer.line
             @column = @lexer.column
             @lexer.next_token || Piga::Token.new(:EOF, "\0", @line, @column)
            else
              Piga::Token.new(:EOF, "\0", @line, @column)
            end
        @tokens << t.dup
      end

      @tokens[@pos]
    end

    def next
      token = peek
      @pos += 1
      token
    end
  end
end

# piga/parser.rb
module Piga
  class Parser
    attr_reader :token_stream

    def initialize lexer
      @lexer = lexer
      @token_stream = TokenStream.new lexer
    end

    def pos
      @token_stream.pos
    end

    def reset index
      @token_stream.pos = index
    end

    def consume *types
      token = @token_stream.peek
      return @token_stream.next if types.include?(token.type)

      nil
    end

    def consume_star *types
      ret = []
      ret << @token_stream.next while types.include? @token_stream.peek.type
      ret
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

    def skip *types
      @token_stream.next while types.include? @token_stream.peek.type
    end
  end
end

# piga/grammar.rb
# piga/grammar/lexer.rb
# piga/grammar/ast.rb
# piga/grammar/parser.rb
# piga/grammar/generator.rb
module Piga
  module Grammar
    module AST
      Alt = Struct.new :items, :action do
        def to_s
          i = items.map do |i|
            if Object.const_defined?("AST::Token") && i.is_a?(AST::Token)
              i.value.inspect
            else
              i
            end
          end

          if action
            "#{i.join(' ')} #{action}"
          else
            i.join(" ")
          end
        end
      end

      Rule = Struct.new :name, :alts, :action do
        def to_s
          "#{name}\n" \
          "  : #{alts.join("\n  | ")}\n" \
          "  ;"
        end
      end

      Item = Struct.new :value, :zero_or_more, :one_or_more, :literal do
        def literal?
          !!literal
        end

        def to_s
          if zero_or_more
            "#{value}*"
          elsif one_or_more
            "#{value}+"
          else
            value.to_s
          end
        end
      end

      Grammar = Struct.new :directives, :rules do
        # def name
          # directives.select { |d| d.value
        # end
      end
    end

    class Generator
      def error msg
        puts msg
        abort
      end

      def initialize grammar, input_file: nil
        @input_file = input_file
        @grammar = grammar

        raise "no rules" if @grammar.rules.nil?

        @directives = grammar.directives

        @directives.each { |n| on_DERECTIVE n }
        @vars = 0.step
      end

      def on_DERECTIVE node
        type, value = *node.children
        case type
        when "%name"
          unless value[0] == value[0].upcase
            error "class name for `#{type}` must start with an uppercase " \
                  "letter, got `#{value}`"
          end
          @class_name = value
        else
          error "unknown directive type `#{type}`"
        end
      end

      def new_var
        "__#{@vars.next}"
      end

      def generate io = $stdout
        io.puts "# frozen_string_literal: true"
        io.puts
        if @input_file
          io.puts "# **note**: auto-generated from `#{@input_file}`, do not edit."
        else
          io.puts "# **note**: auto-generated, do not edit."
        end
        io.puts "#"
        io.puts "#    $ ruby lib/piga/parser.rb < lib/piga/piga.piga > v2.rb"
        io.puts "#    $ ruby v2.rb < lib/piga/piga.piga > v3.rb"
        io.puts "#    $ diff v2.rb v3.rb "
        io.puts '#    $ if [ -z "`diff v2.rb v3.rb`" ]; then echo "ok"; else echo "fail"; fi'
        io.puts "#"
        io.puts
        io.puts 'require "reline"'
        io.puts
        io.puts 'require "ast"'
        io.puts 'require "piga"'
        io.puts 'require "piga/lexer"'
        io.puts
        io.puts "class #{@class_name} < Piga::Parser"
        io.puts "  include AST::Sexp"
        io.puts
        io.puts "  def parse"
        io.puts "    #{@grammar.rules.first.name}"
        io.puts "  end"

        @grammar.rules.each do |rule|
          io.puts
          # TODO: add rule as comment
          # io.puts "  # #{rule.name}"
          # io.puts "  #   : #{rule.alts.join("\n  #   | ")}"
          io.puts "  def #{rule.name}"
          io.puts "    loc = pos"
          io.puts "    val = []"

          rule.alts.each do |alt|
            ends = []

            # We start matching by making an if statement, branching for each
            # alternative.
            #
            depth = 2
            io.puts

            # TODO: add alternate as comment
            # io.puts "    # #{alt}"

            alt.items.each_with_index do |item, _index|
              is_epsilon = item.value == "_"
              is_token = item.value == item.value.upcase
              indent = " " * (depth += 2)

              if is_epsilon
                io.puts "#{indent}if true"
                io.puts "#{indent}  val << nil"
              elsif is_token
                var = new_var

                if item.zero_or_more
                  io.puts "#{indent}if #{var} = consume_star(:#{item.value})"
                else
                  io.puts "#{indent}if #{var} = consume(:#{item.value})"
                end

                io.puts "#{indent}  val << #{var}"
              else
                var = new_var

                if item.zero_or_more
                  io.puts "#{indent}if #{var} = consume_star_rule(:#{item.value})"
                else
                  io.puts "#{indent}if #{var} = #{item.value}"
                end

                io.puts "#{indent}  val << #{var}"
              end
              ends << indent
            end

            indent = " " * depth
            alt.action ||= "val[0]"

            io.puts "#{indent}  return begin"
            io.puts "#{indent}           #{alt.action}"
            io.puts "#{indent}         end"

            ends.reverse_each do |e|
              io.puts "#{e}else"
              # io.puts "#{e}  val.pop"
              io.puts "#{e}  val = []"
              io.puts "#{e}  reset loc"
              io.puts "#{e}end"
            end
          end

          io.puts "    nil"
          io.puts "  end"
        end
        io.puts "end"
        io.puts
        io.puts "# TODO: rm this"
        io.puts "if $0 == __FILE__"
        io.puts "  case ARGV&.dig 0"
        io.puts "  when '-i', '--interactive'"
        io.puts "    while line = Reline.readline('piga> ', true)"
        io.puts "      lexer = Piga::Grammar::Lexer.new"
        io.puts "      lexer.instance_eval { scan_setup line }"
        io.puts "      parser = #{@class_name}.new(lexer)"
        io.puts "      ast = parser.parse"
        io.puts "      puts ast"
        io.puts "    end"
        io.puts "  else"
        io.puts "    lexer = Piga::Grammar::Lexer.new ARGF.read"
        io.puts "    parser = #{@class_name}.new(lexer)"
        io.puts "    ast = parser.parse"
        io.puts "    gen = Piga::Grammar::Generator.new ast"
        io.puts "    puts gen.generate"
        io.puts "  end"
        io.puts "end"
      end
    end
  end
end
