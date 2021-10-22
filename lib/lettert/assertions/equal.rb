# frozen_string_literal: true

module Lettert
  module Assertions
    class Equal < Assert
      def call(outs)
        outs == expects
      end
    end

    class Unequal < Assert
      def call(outs)
        outs != expects
      end
    end
  end
end
