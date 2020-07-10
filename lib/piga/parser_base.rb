require "piga/scanner"

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
        error "rule `#{r}` is not defined in the grammar" unless respond_to?(r)

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
