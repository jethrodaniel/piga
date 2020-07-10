#!/usr/bin/env ruby
# frozen_string_literal: true

# Simple PEG generator

require "piga/parser_base"

# todo: mv all this into grammar
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
