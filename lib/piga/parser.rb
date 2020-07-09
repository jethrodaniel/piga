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

    if __14 = consume_rule(:_directive)
      val << __14
      if __15 = consume_star_rule(:sp)
        val << __15
        if __16 = consume_rule(:names)
          val << __16
          if __17 = consume_star_rule(:sp)
            val << __17
            if __18 = consume_star(";")
              val << __18
              return begin
                       s(:directive, val[0], *val[2]) 
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
    if __19 = consume_rule(:_directive)
      val << __19
      if __20 = consume_rule(:name)
        val << __20
        if __21 = consume_star_rule(:sp)
          val << __21
          if __22 = consume_rule(:name)
            val << __22
            if __23 = consume_star_rule(:sp)
              val << __23
              if __24 = consume_star(";")
                val << __24
                return begin
                         s(:directive, val[0], val[1], val[3]) 
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

    if __25 = consume_rule(:name)
      val << __25
      if __26 = consume_star_rule(:sp)
        val << __26
        if __27 = consume_rule(:names)
          val << __27
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
    if __28 = consume_rule(:name)
      val << __28
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

    if __29 = consume_rule(:rule)
      val << __29
      if __30 = consume_star_rule(:sp)
        val << __30
        if __31 = consume_rule(:rules)
          val << __31
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
    if __32 = consume_rule(:rule)
      val << __32
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

    if __33 = consume_rule(:name)
      val << __33
      if __34 = consume_star_rule(:sp)
        val << __34
        if __35 = consume(":")
          val << __35
          if __36 = consume_star_rule(:sp)
            val << __36
            if __37 = consume_rule(:alternatives)
              val << __37
              if __38 = consume_star_rule(:sp)
                val << __38
                if __39 = consume(";")
                  val << __39
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

    if __40 = consume_rule(:alternative)
      val << __40
      if __41 = consume_star_rule(:sp)
        val << __41
        if __42 = consume("|")
          val << __42
          if __43 = consume_star_rule(:sp)
            val << __43
            if __44 = consume_rule(:alternatives)
              val << __44
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
    if __45 = consume_rule(:alternative)
      val << __45
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

    if __46 = consume_star_rule(:sp)
      val << __46
      if __47 = consume_rule(:alt)
        val << __47
        if __48 = consume_star_rule(:sp)
          val << __48
          if __49 = consume_rule(:block)
            val << __49
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
    if __50 = consume_star_rule(:sp)
      val << __50
      if __51 = consume_rule(:alt)
        val << __51
        if __52 = consume_star_rule(:sp)
          val << __52
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

    if __53 = consume_rule(:items)
      val << __53
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

    if __54 = consume_rule(:item)
      val << __54
      if __55 = consume_star_rule(:sp)
        val << __55
        if __56 = consume_star_rule(:items)
          val << __56
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

    if __57 = consume_rule(:name)
      val << __57
      if __58 = consume("*")
        val << __58
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
    if __59 = consume_rule(:name)
      val << __59
      if __60 = consume("+")
        val << __60
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
    if __61 = consume_rule(:name)
      val << __61
      return begin
               s(:name, val[0]) 
             end
    else
      reset loc
      val = []
    end
    if __62 = consume_rule(:literal)
      val << __62
      if __63 = consume("*")
        val << __63
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
    if __64 = consume_rule(:literal)
      val << __64
      if __65 = consume("+")
        val << __65
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
    if __66 = consume_rule(:literal)
      val << __66
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

    if __67 = consume_star_rule(:sp)
      val << __67
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

    if __68 = consume("\n")
      val << __68
      return begin
              val[0]
             end
    else
      reset loc
      val = []
    end
    if __69 = consume(" ")
      val << __69
      return begin
              val[0]
             end
    else
      reset loc
      val = []
    end
    if __70 = consume_rule(:comment)
      val << __70
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
