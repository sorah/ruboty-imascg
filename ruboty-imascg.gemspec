# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty-imascg/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-imascg"
  spec.version       = RubotyImascg::VERSION
  spec.authors       = ["Shota Fukumori (sora_h)"]
  spec.email         = ["her@sorah.jp"]
  spec.summary       = %q{Let ruboty find imas_cg cards using ppdb.sekai.in}
  spec.description   = %q{Let ruboty find imas_cg cards using ppdb.sekai.in.
  Thanks @sekaiasia for providing the API.}
  spec.homepage      = "https://github.com/sorah/ruboty-imascg"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ruboty"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
