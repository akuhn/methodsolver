# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'methodsolver/version'

Gem::Specification.new do |spec|
  spec.name          = "methodsolver"
  spec.version       = Methodsolver::VERSION
  spec.authors       = ["Adrian Kuhn"]
  spec.email         = ["akuhn@iam.unibe.ch"]

  spec.summary       = "Finds ruby methods given a block with placeholder."
  spec.homepage      = "https://github.com/akuhn/methodsolver"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
