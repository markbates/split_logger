# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'split_logger/version'

Gem::Specification.new do |spec|
  spec.name          = "split_logger"
  spec.version       = SplitLogger::VERSION
  spec.authors       = ["Mark Bates"]
  spec.email         = ["mark@markbates.com"]
  spec.summary       = %q{This gem let's you write to multiple log destinations at the same time.}
  spec.description   = %q{This gem let's you write to multiple log destinations at the same time.}
  spec.homepage      = "http://github.com/markbates/split_logger"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
end
