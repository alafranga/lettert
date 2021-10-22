# frozen_string_literal: true

require 'open3'

module Lettert
  class Run
    class Result
      attr_reader :out, :err, :status, :argv

      def initialize(out:, err:, status:, argv:)
        @out    = out
        @err    = err
        @status = status || 0
        @argv   = argv
      end

      def ok?
        status.zero?
      end

      def notok?
        !ok?
      end

      def cmd
        @cmd ||= argv.join(' ')
      end

      def desc
        "Command #{ok? ? 'succeeded' : "failed with exit code#{status}"}: #{cmd}"
      end

      def outs
        @outs ||= out.split("\n")
      end

      def errs
        @errs ||= err.split("\n")
      end
    end

    private_constant :Result

    def self.call(*args)
      out, err, status = Open3.capture3(*args, stdin_data: $stdin.tty? ? '' : $stdin.read)

      Result.new out: out, err: err, argv: args, status: status.exitstatus
    end
  end
end
