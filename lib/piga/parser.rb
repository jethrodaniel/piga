# frozen_string_literal: true

# **note**: auto-generated from `lib/grammar.piga`, do not edit.
#
#    $ bundle exec ruby parser.rb # for instance
#

require "reline"

require "ast"
require "piga"

class P < Piga::Parser
  include AST::Sexp

  def parse
    grammar
  end

  def grammar
    loc = pos
    val = []

    if __0 = consume_star_rule(:sp)
      val << __0
      if __1 = directives
        val << __1
        if __2 = consume_star_rule(:sp)
          val << __2
          if __3 = rules
            val << __3
            return begin
                     
      Piga::Grammar::AST::Grammar.new val[1], val[3]
    
                   end
          else
            val = []
            reset loc
          end
        else
          val = []
          reset loc
        end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end

    if __4 = consume_star_rule(:sp)
      val << __4
      if __5 = directive
        val << __5
        if __6 = consume_star_rule(:sp)
          val << __6
          if __7 = rules
            val << __7
            return begin
                     
      Piga::Grammar::AST::Grammar.new val[1], val[3]
    
                   end
          else
            val = []
            reset loc
          end
        else
          val = []
          reset loc
        end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end

    if __8 = consume_star_rule(:sp)
      val << __8
      if __9 = rules
        val << __9
        return begin
                  Piga::Grammar::AST::Grammar.new [], val[1] 
               end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end
    nil
  end

  def directives
    loc = pos
    val = []

    if __10 = directive
      val << __10
      if __11 = consume_star_rule(:sp)
        val << __11
        if __12 = directives
          val << __12
          return begin
                    [val[0], *val[2]] 
                 end
        else
          val = []
          reset loc
        end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end

    if __13 = directive
      val << __13
      return begin
                [val[0]] 
             end
    else
      val = []
      reset loc
    end
    nil
  end

  def directive
    loc = pos
    val = []

    if __14 = consume(:DIRECTIVE)
      val << __14
      if __15 = consume_star_rule(:sp)
        val << __15
        if __16 = names
          val << __16
          if __17 = consume_star_rule(:sp)
            val << __17
            if __18 = consume_star(:SEMI)
              val << __18
              return begin
                        s(:DIRECTIVE, val[0].value, *val[2...-1].flatten.map(&:value)) 
                     end
            else
              val = []
              reset loc
            end
          else
            val = []
            reset loc
          end
        else
          val = []
          reset loc
        end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end

    if __19 = consume(:DIRECTIVE)
      val << __19
      if __20 = consume_star_rule(:sp)
        val << __20
        if __21 = consume(:NAME)
          val << __21
          if __22 = consume_star_rule(:sp)
            val << __22
            if __23 = consume_star(:SEMI)
              val << __23
              return begin
                        s(:DIRECTIVE, val[0].value, *val[2].value) 
                     end
            else
              val = []
              reset loc
            end
          else
            val = []
            reset loc
          end
        else
          val = []
          reset loc
        end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end
    nil
  end

  def names
    loc = pos
    val = []

    if __24 = consume(:NAME)
      val << __24
      if __25 = consume_star_rule(:sp)
        val << __25
        if __26 = names
          val << __26
          return begin
                    [val[0], *val[2..-1]] 
                 end
        else
          val = []
          reset loc
        end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end

    if __27 = consume(:NAME)
      val << __27
      return begin
                [val[0]] 
             end
    else
      val = []
      reset loc
    end
    nil
  end

  def rules
    loc = pos
    val = []

    if __28 = rule
      val << __28
      if __29 = consume_star_rule(:sp)
        val << __29
        if __30 = rules
          val << __30
          return begin
                    [val[0], *val[2]] 
                 end
        else
          val = []
          reset loc
        end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end

    if __31 = rule
      val << __31
      return begin
                [val[0]] 
             end
    else
      val = []
      reset loc
    end
    nil
  end

  def rule
    loc = pos
    val = []

    if __32 = consume(:NAME)
      val << __32
      if __33 = consume_star_rule(:sp)
        val << __33
        if __34 = consume(:COLON)
          val << __34
          if __35 = consume_star_rule(:sp)
            val << __35
            if __36 = alternatives
              val << __36
              if __37 = consume_star_rule(:sp)
                val << __37
                if __38 = consume(:SEMI)
                  val << __38
                  return begin
                            Piga::Grammar::AST::Rule.new val[0].value, val[4] 
                         end
                else
                  val = []
                  reset loc
                end
              else
                val = []
                reset loc
              end
            else
              val = []
              reset loc
            end
          else
            val = []
            reset loc
          end
        else
          val = []
          reset loc
        end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end
    nil
  end

  def alternatives
    loc = pos
    val = []

    if __39 = alternative
      val << __39
      if __40 = consume_star_rule(:sp)
        val << __40
        if __41 = consume(:PIPE)
          val << __41
          if __42 = consume_star_rule(:sp)
            val << __42
            if __43 = alternatives
              val << __43
              return begin
                        [val[0], *val[4]] 
                     end
            else
              val = []
              reset loc
            end
          else
            val = []
            reset loc
          end
        else
          val = []
          reset loc
        end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end

    if __44 = alternative
      val << __44
      return begin
                [val.first] 
             end
    else
      val = []
      reset loc
    end
    nil
  end

  def alternative
    loc = pos
    val = []

    if __45 = consume_star_rule(:sp)
      val << __45
      if __46 = alt
        val << __46
        if __47 = consume_star_rule(:sp)
          val << __47
          if __48 = consume(:BLOCK)
            val << __48
            return begin
                      Piga::Grammar::AST::Alt.new(val[1], val[3].value[1...-1]) 
                   end
          else
            val = []
            reset loc
          end
        else
          val = []
          reset loc
        end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end

    if __49 = consume_star_rule(:sp)
      val << __49
      if __50 = alt
        val << __50
        if __51 = consume_star_rule(:sp)
          val << __51
          return begin
                    Piga::Grammar::AST::Alt.new(val[1], "val[0]") 
                 end
        else
          val = []
          reset loc
        end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end
    nil
  end

  def alt
    loc = pos
    val = []

    if __52 = items
      val << __52
      return begin
               val[0]
             end
    else
      val = []
      reset loc
    end
    nil
  end

  def items
    loc = pos
    val = []

    if __53 = item
      val << __53
      if __54 = consume_star_rule(:sp)
        val << __54
        if __55 = consume_star_rule(:items)
          val << __55
          return begin
                    [val[0], *val[2..-1]].flatten 
                 end
        else
          val = []
          reset loc
        end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end
    nil
  end

  def item
    loc = pos
    val = []

    if __56 = consume(:NAME)
      val << __56
      if __57 = consume(:STAR)
        val << __57
        return begin
                  Piga::Grammar::AST::Item.new(val[0].value, true) 
               end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end

    if __58 = consume(:NAME)
      val << __58
      if __59 = consume(:PLUS)
        val << __59
        return begin
                  Piga::Grammar::AST::Item.new(val[0].value, false, true) 
               end
      else
        val = []
        reset loc
      end
    else
      val = []
      reset loc
    end

    if __60 = consume(:NAME)
      val << __60
      return begin
                Piga::Grammar::AST::Item.new(val[0].value) 
             end
    else
      val = []
      reset loc
    end
    nil
  end

  def sps
    loc = pos
    val = []

    if __61 = consume_star_rule(:sp)
      val << __61
      return begin
                val 
             end
    else
      val = []
      reset loc
    end
    nil
  end

  def sp
    loc = pos
    val = []

    if __62 = consume(:SPACE)
      val << __62
      return begin
               val[0]
             end
    else
      val = []
      reset loc
    end

    if __63 = consume(:NEWLINE)
      val << __63
      return begin
               val[0]
             end
    else
      val = []
      reset loc
    end

    if __64 = consume(:COMMENT)
      val << __64
      return begin
               val[0]
             end
    else
      val = []
      reset loc
    end
    nil
  end
end

# TODO: rm this
if $0 == __FILE__
  while line = Reline.readline('piga> ', true)
    lexer = Piga::Grammar::Lexer.new line
    parser = P.new(lexer)
    ast = parser.parse
    puts ast
  end
end

