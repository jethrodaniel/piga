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
      if __5 = consume_rule(:directive)
        val << __5
        if __6 = consume_star_rule(:sp)
          val << __6
          if __7 = consume_rule(:rules)
            val << __7
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
    if __8 = consume_star_rule(:sp)
      val << __8
      if __9 = consume_rule(:rules)
        val << __9
        return begin
                 s(:grammar, [], val[3]) 
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

    if __10 = consume_rule(:directive)
      val << __10
      if __11 = consume_star_rule(:sp)
        val << __11
        if __12 = consume_rule(:directives)
          val << __12
          return begin
                   s(:directives, val[0], *val[2]) 
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
    if __13 = consume_rule(:directive)
      val << __13
      return begin
               s(:directives, val[0]) 
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

    if __14 = consume("%")
      val << __14
      if __15 = consume_rule(:name)
        val << __15
        if __16 = consume_star_rule(:sp)
          val << __16
          if __17 = consume_rule(:names)
            val << __17
            if __18 = consume_star_rule(:sp)
              val << __18
              if __19 = consume_star(";")
                val << __19
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
    if __20 = consume("%")
      val << __20
      if __21 = consume_rule(:name)
        val << __21
        if __22 = consume_star_rule(:sp)
          val << __22
          if __23 = consume_rule(:name)
            val << __23
            if __24 = consume_star_rule(:sp)
              val << __24
              if __25 = consume_star(";")
                val << __25
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

  def names
    loc = pos
    val = []

    if __26 = consume_rule(:name)
      val << __26
      if __27 = consume_star_rule(:sp)
        val << __27
        if __28 = consume_rule(:names)
          val << __28
          return begin
                   [val[0], *val[2..-1]] 
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
    if __29 = consume_rule(:name)
      val << __29
      return begin
               [val[0]] 
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

    if __30 = consume_rule(:rule)
      val << __30
      if __31 = consume_star_rule(:sp)
        val << __31
        if __32 = consume_rule(:rules)
          val << __32
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
    if __33 = consume_rule(:rule)
      val << __33
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

    if __34 = consume_rule(:name)
      val << __34
      if __35 = consume_star_rule(:sp)
        val << __35
        if __36 = consume(":")
          val << __36
          if __37 = consume_star_rule(:sp)
            val << __37
            if __38 = consume_rule(:alternatives)
              val << __38
              if __39 = consume_star_rule(:sp)
                val << __39
                if __40 = consume(";")
                  val << __40
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

    if __41 = consume_rule(:alternative)
      val << __41
      if __42 = consume_star_rule(:sp)
        val << __42
        if __43 = consume("|")
          val << __43
          if __44 = consume_star_rule(:sp)
            val << __44
            if __45 = consume_rule(:alternatives)
              val << __45
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
    if __46 = consume_rule(:alternative)
      val << __46
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

    if __47 = consume_star_rule(:sp)
      val << __47
      if __48 = consume_rule(:alt)
        val << __48
        if __49 = consume_star_rule(:sp)
          val << __49
          if __50 = consume_rule(:block)
            val << __50
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
    if __51 = consume_star_rule(:sp)
      val << __51
      if __52 = consume_rule(:alt)
        val << __52
        if __53 = consume_star_rule(:sp)
          val << __53
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

    if __54 = consume_rule(:items)
      val << __54
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

    if __55 = consume_rule(:item)
      val << __55
      if __56 = consume_star_rule(:sp)
        val << __56
        if __57 = consume_star_rule(:items)
          val << __57
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

    if __58 = consume_rule(:name)
      val << __58
      if __59 = consume("*")
        val << __59
        return begin
                 s(:zero_or_more, s(:name, val[0])) 
               end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end
    if __60 = consume_rule(:name)
      val << __60
      if __61 = consume("+")
        val << __61
        return begin
                 s(:one_or_more, s(:name, val[0])) 
               end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end
    if __62 = consume_rule(:name)
      val << __62
      return begin
               s(:name, val[0]) 
             end
    else
      reset loc
      val = []
    end
    if __63 = consume_rule(:literal)
      val << __63
      if __64 = consume("*")
        val << __64
        return begin
                 s(:zero_or_more, s(:literal, val[0])) 
               end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end
    if __65 = consume_rule(:literal)
      val << __65
      if __66 = consume("+")
        val << __66
        return begin
                 s(:one_or_more, s(:literal, val[0])) 
               end
      else
        reset loc
        val = []
      end
    else
      reset loc
      val = []
    end
    if __67 = consume_rule(:literal)
      val << __67
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

    if __68 = consume_star_rule(:sp)
      val << __68
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

    if __69 = consume("\n")
      val << __69
      return begin
              val[0]
             end
    else
      reset loc
      val = []
    end
    if __70 = consume(" ")
      val << __70
      return begin
              val[0]
             end
    else
      reset loc
      val = []
    end
    if __71 = consume_rule(:comment)
      val << __71
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

if $0 == __FILE__
  case ARGV&.dig 0
  when '-i', '--interactive'
    while line = Reline.readline("piga> ", true)
      parser = Piga::Grammar::Parser.new(line)
      ast = parser.parse
      puts ast
    end
  else
    parser = Piga::Grammar::Parser.new(ARGF.read)
    ast = parser.parse
    require "piga/generator"
    gen = Piga::Generator.new
    gen.process(ast)
  end
end
