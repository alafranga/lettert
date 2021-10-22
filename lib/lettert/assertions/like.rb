# frozen_string_literal: true

module Lettert
  module Assertions
    class Like < Assert
      def call(outs)
        expects.all? { |expect| outs.any? { |actual| actual.include? expect } }
      end
    end

    class Unlike
      def call(outs)
        expects.all? { |expect| outs.none? { |actual| actual.include? expect } }
      end
    end
  end
end
