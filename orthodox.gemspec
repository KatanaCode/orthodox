# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "orthodox/version"

Gem::Specification.new do |spec|
  spec.name          = "orthodox"
  spec.version       = Orthodox::VERSION
  spec.authors       = ["Bodacious", 'CodeMeister']
  spec.email         = ["team@katanacode.com"]

  spec.summary       = %q{Better Rails generators for Katana}
  spec.description   = %q{Replaces Rails generators with generators specific to Katana's workflow'}
  spec.homepage      = "https://github.com/KatanaCode/orthodox"
  spec.license       = "MIT"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", 'lib/generators']
  spec.add_dependency 'rails', '>= 3.0.0'
  spec.add_dependency 'slim-rails'
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end
