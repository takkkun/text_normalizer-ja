# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'text_normalizer-ja/version'

Gem::Specification.new do |gem|
  gem.name          = 'text_normalizer-ja'
  gem.version       = TextNormalizer::Ja::VERSION
  gem.authors       = ['Takahiro Kondo']
  gem.email         = ['heartery@gmail.com']
  gem.description   = %q{Japanese text normalizer}
  gem.summary       = %q{Work for Japanese text (string and morphemes) normalization}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency('multilang')

  gem.add_development_dependency('rspec')
end
