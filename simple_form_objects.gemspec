# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_form_object/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_form_object"
  spec.version       = SimpleFormObject::VERSION
  spec.authors       = ["Leonard Garvey"]
  spec.email         = ["lengarvey@gmail.com"]
  spec.summary       = %q{Simple form objects for simple form and rails}
  spec.description   = %q{Very simple form objects for simple form and rails}
  spec.homepage      = "http://github.com/reinteractive-open/simple_form_object"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", ">= 4.0"
  spec.add_dependency "activesupport", ">= 4.0"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
