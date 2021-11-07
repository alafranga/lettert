# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'lettert/version'

Gem::Specification.new do |s|
  s.name        = 'lettert'
  s.author      = 'Recai Oktaş'
  s.email       = 'roktas@gmail.com'
  s.license     = 'GPL-3.0-or-later'
  s.version     = Lettert::VERSION.dup
  s.summary     = 'Assertions for command line programs'
  s.description = 'Assertions for command line programs'

  s.homepage      = 'https://alaturka.github.io/lettert'
  s.files         = Dir['[A-Z][A-Z]*', 'lettert.gemspec', 'lib/**/*']
  s.executables   = %w[t]
  s.require_paths = %w[lib]

  s.metadata['changelog_uri']     = 'https://github.com/alaturka/lettert/blob/master/CHANGELOG.md'
  s.metadata['source_code_uri']   = 'https://github.com/alaturka/lettert'
  s.metadata['bug_tracker_uri']   = 'https://github.com/alaturka/lettert/issues'

  s.required_ruby_version = '>= 2.7.0' # rubocop:disable Gemspec/RequiredRubyVersion
end
