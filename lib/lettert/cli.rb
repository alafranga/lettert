# frozen_string_literal: true

module Lettert
  module CLI
    BANNER = <<~BANNER.freeze
      Usage: #{$PROGRAM_NAME} [<flags>] <assertion> [<expectations>] <command> [args...]

      Flags:

          -success               Expect successful exit code
          -failure               Expect failure exit code
          -mute                  Mute STDIN
          -quiet                 Run quietly
          -help                  Show this help
          -version               Show version

      Assertions:
    BANNER

    FLAGS = {
      failure: nil,
      help:    nil,
      mute:    false,
      quiet:   false,
      success: nil,
      version: nil
    }.freeze

    def self.run(args)
      argv, topic, flags = parse(args)
      Assert.call!(argv, topic, **flags)
    rescue Error => e
      abort e.message.to_s
    end

    class << self
      private

      def parse(args) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/PerceivedComplexity
        Signal.trap('INT') { Kernel.abort '' }

        flags = FLAGS.dup
        argv  = []
        topic = nil

        while (arg = args&.shift)
          unless arg.start_with? '-'
            args.unshift arg
            break
          end

          key = arg.delete_prefix('-').to_sym
          abort "Invalid option: #{arg}" unless flags.key?(key)

          flags[key] = true
        end

        usage    if args.empty?
        usage(0) if flags[:help]
        version  if flags[:version]

        abort 'Too few arguments' if args.size < 2

        while (arg = args&.shift)
          if arg == '--'
            topic = args&.join(' ')
            break
          end
          argv << arg
        end

        [argv, topic, flags]
      end

      def usage(exit_code = 1)
        warn BANNER
        warn Assert::ASSERTIONS.dump(14).map { |line| "    #{line}" }.join("\n")

        exit exit_code
      end

      def version
        puts Assert::VERSION

        exit 0
      end
    end
  end
end
