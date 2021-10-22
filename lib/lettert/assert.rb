# frozen_string_literal: true

module Lettert
  class Assert
    Assertion = Struct.new :symbol, :desc, :argc, :on, :success do
      def self.call(*args)
        new(*args)
      end

      def klass
        Assertions.const_get(symbol)
      end
    end

    private_constant :Assertion

    ASSERTIONS = {
      'ok'        => Assertion.(:Ok,       'Command must succeed',                           1),
      'notok'     => Assertion.(:Notok,    'Command must fail',                              1),
      'equal'     => Assertion.(:Equal,    'Command must succeed and stdout must equal',     2, :outs, true),
      'equal-'    => Assertion.(:Equal,    'Command must fail and stderr must like',         2, :errs, false),
      'unequal'   => Assertion.(:Unequal,  'Command must succeed and stdout must unequal',   2, :outs, true),
      'unequal-'  => Assertion.(:Unequal,  'Command must fail and stderr must unequal',      2, :errs, false),
      'like'      => Assertion.(:Like,     'Command must succeed and stdout must like',      2, :outs, true),
      'like-'     => Assertion.(:Like,     'Command must fail and stderr must like',         2, :errs, false),
      'unlike'    => Assertion.(:Unlike,   'Command must succeed and stdout must unlike',    2, :outs, true),
      'unlike-'   => Assertion.(:Unlike,   'Command must fail and stderr must unlike',       2, :errs, false),
      'match'     => Assertion.(:Match,    'Command must succeed and stdout must match',     2, :outs, true),
      'match-'    => Assertion.(:Match,    'Command must fail and stderr must match',        2, :errs, false),
      'mismatch'  => Assertion.(:Mismatch, 'Command must succeed and stdout must not match', 2, :outs, true),
      'mismatch-' => Assertion.(:Mismatch, 'Command must fail and stderr must not match',    2, :errs, false)
    }.tap do |this|
      def this.dump(spaces = 14)
        longest = keys.map(&:length).max
        map { |name, assertion| "#{name.ljust(longest)}#{' ' * spaces}#{assertion.desc}" }
      end
    end.freeze

    class Result
      attr_reader :topic, :status, :messages

      def initialize(topic, status, *messages)
        @topic    = topic
        @status   = status
        @messages = messages
      end

      def flush!(**kwargs)
        summary = report(**kwargs)
        status ? warn(summary) : abort(summary)
      end

      def report(**kwargs)
        header, sign = status ? %W[#{topic || 'Ok'} ✓] : %W[#{topic || 'Not Ok'} ✗]
        message = "#{sign} #{header}"

        return message if kwargs[:quiet]

        [message, '', *messages].join("\n")
      end

      class << self
        def failure(topic = nil, *messages)
          new(topic, false, *messages)
        end

        def success(topic = nil, *messages)
          new(topic, true, *messages)
        end
      end
    end

    private_constant :Result

    attr_reader :args, :expects, :cmd

    def initialize(args)
      @args = args
      setup
    end

    def assert(on:, success: true, topic: nil)
      asserted = call(outs = (result = run).public_send(on))

      if success && result.notok?
        return Result.failure(topic, "Command expected to be succeeded where it failed: #{result.cmd}")
      end

      if !success && result.ok?
        return Result.failure(topic, "Command expected to be failed where it succeeded: #{result.cmd}")
      end

      asserted ? Result.success(topic) : Result.failure(topic, *details(outs))
    end

    def run
      Run.(*cmd)
    end

    private

    def setup
      @expects = args.first.split Regexp.escape("\n")
      @cmd     = args[1..]
    end

    def patternize
      expects.map { |expect| Regexp.new(expect) }
    end

    def details(outs)
      [].tap do |details|
        details.append fmt('Expected', expects)
        details.append fmt('  Actual', outs)
      end
    end

    def fmt(title, strings)
      strings && !strings.empty? ? ["#{title}:", *strings.map { |string| "\t#{string}" }] : ["#{title}: -"]
    end

    class << self
      def call(argv, topic = nil, **flags)
        unless (assertion = ASSERTIONS[name = argv.shift])
          raise Error, "No such assertion: #{name}"
        end

        raise Error, 'Too few arguments' if argv.size < assertion.argc

        success = flags[:success].nil? ? assertion.success : flags[:success]
        on      = assertion.on

        assertion.klass.new(argv).assert(on: on, success: success, topic: topic)
      end

      def call!(argv, topic = nil, **flags)
        call(argv, topic, **flags).flush!(**flags)
      end
    end
  end
end
