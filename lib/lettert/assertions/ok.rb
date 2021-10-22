# frozen_string_literal: true

module Lettert
  module Assertions
    class Ok < Assert
      def assert(**kwargs)
        run ? Result.success(kwargs[:topic]) : Result.failure(kwargs[:topic])
      end

      private

      def setup
        @cmd = args
      end
    end

    class Notok < Ok
      def assert(**kwargs)
        run ? Result.failure(kwargs[:topic]) : Result.success(kwargs[:topic])
      end
    end
  end
end
