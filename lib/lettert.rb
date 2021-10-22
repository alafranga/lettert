# frozen_string_literal: true

require_relative 'lettert/errors'
require_relative 'lettert/version'
require_relative 'lettert/run'
require_relative 'lettert/assert'
require_relative 'lettert/assertions'
require_relative 'lettert/cli'

module Lettert
  def self.main(args = ARGV)
    CLI.run(args)
  end
end
