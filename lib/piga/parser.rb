#!/usr/bin/env ruby
# frozen_string_literal: true

require "reline"
require "piga"
require "ast"

class Piga::Grammar::Parser < Piga::Parser
  include AST::Sexp

  def parse
    grammar
  end

  def handler_missing node
    error "no handler for node: #{node.type}"
  end

  def grammar
    loc = pos
    val = []

    if __0 = consume_star_rule(:sp)
      val << __0
      if __1 = consume_rule(:directives)
        val << __1
        if __2 = consume_star_rule(:sp)
          val << __2
          if __3 = consume_rule(:rules)
            val << __3
            return begin
                     s(:grammar, val[1], val[3]) 
                   end
          else
            reset loc
            val = []
          end
        else
          reset loc
          val = []
        end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end
    if __4 = consume_star_rule(:sp)
      val << __4
      if __5 = consume_rule(:rules)
        val << __5
        return begin
                 s(:grammar, [], val[1]) 
               end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end

    nil
  end

  def directives
    loc = pos
    val = []

    if __6 = consume_star_rule(:sp)
      val << __6
      if __7 = consume_rule(:directive)
        val << __7
        if __8 = consume_star_rule(:sp)
          val << __8
          if __9 = consume_rule(:directives)
            val << __9
            return begin
                     s(:directives, val[1], *val[3]) 
                   end
          else
            reset loc
            val = []
          end
        else
          reset loc
          val = []
        end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end
    if __10 = consume_star_rule(:sp)
      val << __10
      if __11 = consume_rule(:directive)
        val << __11
        return begin
                 s(:directives, val[1]) 
               end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end

    nil
  end

  def directive
    loc = pos
    val = []

    if __12 = consume("%")
      val << __12
      if __13 = consume_rule(:name)
        val << __13
        if __14 = consume_star_rule(:sp)
          val << __14
          if __15 = consume_star_rule(:literal)
            val << __15
            if __16 = consume_star_rule(:sp)
              val << __16
              if __17 = consume_star(";")
                val << __17
                return begin
                         s(:directive, val[1], *val[3]) 
                       end
              else
                reset loc
                val = []
              end
            else
              reset loc
              val = []
            end
          else
            reset loc
            val = []
          end
        else
          reset loc
          val = []
        end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end
    if __18 = consume("%")
      val << __18
      if __19 = consume_rule(:name)
        val << __19
        if __20 = consume_star_rule(:sp)
          val << __20
          if __21 = consume_rule(:literal)
            val << __21
            if __22 = consume_star_rule(:sp)
              val << __22
              if __23 = consume_star(";")
                val << __23
                return begin
                         s(:directive, val[1], val[3]) 
                       end
              else
                reset loc
                val = []
              end
            else
              reset loc
              val = []
            end
          else
            reset loc
            val = []
          end
        else
          reset loc
          val = []
        end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end

    nil
  end

  def rules
    loc = pos
    val = []

    if __24 = consume_rule(:rule)
      val << __24
      if __25 = consume_star_rule(:sp)
        val << __25
        if __26 = consume_rule(:rules)
          val << __26
          return begin
                   s(:rules, val[0], *val[2]) 
                 end
        else
          reset loc
          val = []
        end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end
    if __27 = consume_rule(:rule)
      val << __27
      return begin
               s(:rules, val[0]) 
             end
    else
      reset loc
      val = []
    end

    nil
  end

  def rule
    loc = pos
    val = []

    if __28 = consume_rule(:name)
      val << __28
      if __29 = consume_star_rule(:sp)
        val << __29
        if __30 = consume(":")
          val << __30
          if __31 = consume_star_rule(:sp)
            val << __31
            if __32 = consume_rule(:alternatives)
              val << __32
              if __33 = consume_star_rule(:sp)
                val << __33
                if __34 = consume(";")
                  val << __34
                  return begin
                           s(:rule, val[0], val[4]) 
                         end
                else
                  reset loc
                  val = []
                end
              else
                reset loc
                val = []
              end
            else
              reset loc
              val = []
            end
          else
            reset loc
            val = []
          end
        else
          reset loc
          val = []
        end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end

    nil
  end

  def alternatives
    loc = pos
    val = []

    if __35 = consume_rule(:alternative)
      val << __35
      if __36 = consume_star_rule(:sp)
        val << __36
        if __37 = consume("|")
          val << __37
          if __38 = consume_star_rule(:sp)
            val << __38
            if __39 = consume_rule(:alternatives)
              val << __39
              return begin
                       s(:alternatives, val[0], *val[4]) 
                     end
            else
              reset loc
              val = []
            end
          else
            reset loc
            val = []
          end
        else
          reset loc
          val = []
        end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end
    if __40 = consume_rule(:alternative)
      val << __40
      return begin
               s(:alternatives, val[0]) 
             end
    else
      reset loc
      val = []
    end

    nil
  end

  def alternative
    loc = pos
    val = []

    if __41 = consume_star_rule(:sp)
      val << __41
      if __42 = consume_rule(:alt)
        val << __42
        if __43 = consume_star_rule(:sp)
          val << __43
          if __44 = consume_rule(:block)
            val << __44
            return begin
                     s(:alt, s(:items, *val[1]), s(:action, val[3])) 
                   end
          else
            reset loc
            val = []
          end
        else
          reset loc
          val = []
        end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end
    if __45 = consume_star_rule(:sp)
      val << __45
      if __46 = consume_rule(:alt)
        val << __46
        if __47 = consume_star_rule(:sp)
          val << __47
          return begin
                   s(:alt, s(:items, *val[1]), s(:action, "val[0]")) 
                 end
        else
          reset loc
          val = []
        end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end

    nil
  end

  def alt
    loc = pos
    val = []

    if __48 = consume_rule(:items)
      val << __48
      return begin
              val[0]
             end
    else
      reset loc
      val = []
    end

    nil
  end

  def items
    loc = pos
    val = []

    if __49 = consume_rule(:item)
      val << __49
      if __50 = consume_star_rule(:sp)
        val << __50
        if __51 = consume_star_rule(:items)
          val << __51
          return begin
                   [val[0], *val[2..-1]].flatten 
                 end
        else
          reset loc
          val = []
        end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end

    nil
  end

  def item
    loc = pos
    val = []

    if __52 = consume_rule(:prim)
      val << __52
      if __53 = consume("*")
        val << __53
        return begin
                 s(:zero_or_more, val[0]) 
               end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end
    if __54 = consume_rule(:prim)
      val << __54
      if __55 = consume("+")
        val << __55
        return begin
                 s(:one_or_more, val[0]) 
               end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end
    if __56 = consume_rule(:prim)
      val << __56
      return begin
              val[0]
             end
    else
      reset loc
      val = []
    end

    nil
  end

  def prim
    loc = pos
    val = []

    if __57 = consume_rule(:name)
      val << __57
      return begin
               s(:name, val[0]) 
             end
    else
      reset loc
      val = []
    end
    if __58 = consume_rule(:literal)
      val << __58
      return begin
               s(:literal, val[0]) 
             end
    else
      reset loc
      val = []
    end

    nil
  end

  def sps
    loc = pos
    val = []

    if __59 = consume_star_rule(:sp)
      val << __59
      return begin
               val 
             end
    else
      reset loc
      val = []
    end

    nil
  end

  def sp
    loc = pos
    val = []

    if __60 = consume("\n")
      val << __60
      return begin
              val[0]
             end
    else
      reset loc
      val = []
    end
    if __61 = consume(" ")
      val << __61
      return begin
              val[0]
             end
    else
      reset loc
      val = []
    end
    if __62 = consume_rule(:comment)
      val << __62
      return begin
              val[0]
             end
    else
      reset loc
      val = []
    end

    nil
  end

end

if $0 == __FILE__ || $piga_exe
  case ARGV&.dig 0
  when '-i', '--interactive'
    while line = Reline.readline("piga> ", true)
      parser = Piga::Grammar::Parser.new(line)
      ast = parser.parse
      puts ast
    end
  else
    require "piga/generator"
    parser = Piga::Grammar::Parser.new(ARGF.read)
    ast = parser.parse
    gen = Piga::Generator.new
    gen.process(ast)
  end
end
