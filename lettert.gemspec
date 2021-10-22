# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'lettert/version'

Gem::Specification.new do |s|
  s.name        = 'lettert'
  s.author      = 'Recai Oktaş'
  s.email       = 'roktas@gmail.com'
  s.license     = 'GPL-3.0-or-later'
  s.version     = lettert::VERSION.dup
  s.summary     = 'Assertions for command line programs'
  s.description = 'Assertions for command line programs'

  s.homepage      = 'https://alaturka.github.io/lettert'
  s.files         = Dir['CHANGELOG.md', 'LICENSE.md', 'README.md', 'lettert.gemspec', 'lib/**/*']
  s.executables   = %w[t]
  s.require_paths = %w[lib]

  s.metadata['changelog_uri']     = 'https://github.com/alaturka/lettert/blob/master/CHANGELOG.md'
  s.metadata['source_code_uri']   = 'https://github.com/alaturka/lettert'
  s.metadata['bug_tracker_uri']   = 'https://github.com/alaturka/lettert/issues'

  s.required_ruby_version = '>= 2.7.0' # rubocop:disable Gemspec/RequiredRubyVersion

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'minitest-focus', '>= 1.2.1'
  s.add_development_dependency 'minitest-reporters', '>= 1.4.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-minitest'
  s.add_development_dependency 'rubocop-performance'
  s.add_development_dependency 'rubocop-rake'
  s.add_development_dependency 'rubygems-tasks'
end
