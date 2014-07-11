# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rpdf/version'

Gem::Specification.new do |spec|
  spec.name          = "rpdf"
  spec.version       = Rpdf::VERSION
  spec.authors       = ["INTERSAIL"]
  spec.email         = ["cristiano.boncompagni@intersail.it"]
  spec.summary       = %q{ZapPdf Client for Ruby}
  spec.description   = %q{ZapPdf Client for Ruby with interface on WsZapPdf}
  spec.homepage      = "http://www.zapsuite.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 0'

  spec.add_runtime_dependency "savon", "~> 2.0"
end
