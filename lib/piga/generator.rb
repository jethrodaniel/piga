require "ast"

module Piga
  class Generator
    include AST::Processor::Mixin
    include AST::Sexp

    def initialize
      @directives = {}
      @class_name = "Parser"
      @prompt = "piga> "
      @indent = 0
      @var_enum = 0.step
    end

    def new_var
      "__#{@var_enum.next}"
    end

    def indention
      " " * @indent
    end

    def indent
      @indent += 2
    end

    def dedent
      @indent -= 2 if @indent - 2 >= 0
    end

    def on_grammar node
      directives, rules = *node.children
      process_all directives

      puts <<~CODE
        #!/usr/bin/env ruby
        # frozen_string_literal: true

        require "reline"
        require "piga"
        require "ast"

        #{indention}class #{@class_name} < Piga::Parser
        #{indention}  include AST::Sexp

        #{indention}  def parse
        #{indention}    #{rules.children.first.children[0]}
        #{indention}  end

        #{indention}  def handler_missing node
        #{indention}    error "no handler for node: \#{node.type}"
        #{indention}  end

      CODE

      process_all rules

      dedent
      puts <<~CODE
        #{indention}end

        if $0 == __FILE__
          case ARGV&.dig 0
          when '-i', '--interactive'
            while line = Reline.readline(\"#{@prompt}\", true)
              parser = #{@class_name}.new(line)
              ast = parser.parse
              puts ast
            end
          else
            parser = #{@class_name}.new(ARGF.read)
            ast = parser.parse
            require "piga/generator"
            gen = Piga::Generator.new
            gen.process(ast)
          end
        end
      CODE
      nil
    end

    def on_rule node
      indent
      name, *alts = *node.children

      # puts node.to_s.split("\n").map { |l| "#{indention}# #{l}" }.join("\n")
      puts "#{indention}def #{name}"
      puts "#{indention}  loc = pos"
      puts "#{indention}  val = []"
      puts

      process_all alts.first

      puts
      puts "#{indention}  nil"
      puts "#{indention}end"
      puts
      dedent
    end

    def on_alt node
      items, action = *node.children

      process_all items

      a = action.children.first.split("\n").map do |line|
        "#{indention}          #{line}"
      end

      indent
      puts "#{indention}return begin"
      puts a.join("\n")
      puts "#{indention}       end"

      n = items.children.sum do |item|
        if %i[name literal].include? item.type
          1
        else
          item.children.size
        end
      end

      n.times do
        dedent
        puts "#{indention}else"
        puts "#{indention}  reset loc"
        puts "#{indention}  val = []"
        puts "#{indention}end"
      end
      dedent
    end

    def on_zero_or_more node
      indent
      var = new_var
      name, *_ = node.children
      m = name.children.first
      # puts node.to_s.split("\n").map { |l| "#{indention}# #{l}" }.join("\n")
      if name.type == :literal
        puts "#{indention}if #{var} = consume_star(\"#{m}\")"
      else
        puts "#{indention}if #{var} = consume_star_rule(:#{m})"
      end
      puts "#{indention}  val << #{var}"
    end

    def on_one_or_more node
      indent
      var = new_var
      name, *_ = node.children
      m = name.children.first
      # puts node.to_s.split("\n").map { |l| "#{indention}# #{l}" }.join("\n")
      if name.type == :literal
        puts "#{indention}if #{var} = consume_plus(\"#{m}\")"
      else
        puts "#{indention}if #{var} = consume_plus_rule(:#{name.type})"
      end
      puts "#{indention}  val << #{var}"
    end

    def on_name node
      indent
      name, value = *node.children
      var = new_var
      # puts node.to_s.split("\n").map { |l| "#{indention}# #{l}" }.join("\n")
      puts "#{indention}if #{var} = consume_rule(:#{name})"
      puts "#{indention}  val << #{var}"
    end

    def on_literal node
      indent
      name, value = *node.children
      var = new_var
      # puts node.to_s.split("\n").map { |l| "#{indention}# #{l}" }.join("\n")
      puts "#{indention}if #{var} = consume(\"#{name}\")"
      puts "#{indention}  val << #{var}"
    end

    def on_directive node
      name, *values = *node.children
      case name
      when "name"
        @class_name = values.join " "
      when "prompt"
        @prompt = values.join " "
      else
        # @directives[name] = values.join " "
      end
    end
  end
end
