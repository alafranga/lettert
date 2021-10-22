# frozen_string_literal: true

module Lettert
  module Assertions
    class Match < Assert
      def call(outs)
        patternize(expectation).all? { |pattern| outs.any? { |actual| pattern.match actual } }
      end
    end

    class Mismatch < Assert
      def call(outs)
        patternize(expects).all? { |pattern| outs.none? { |actual| pattern.match actual } }
      end
    end
  end
end
