# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sanitizr/version'

Gem::Specification.new do |spec|
  spec.name          = "sanitizr"
  spec.version       = Sanitizr::VERSION
  spec.authors       = ["coocoder"]
  spec.email         = ["delaneyb@fullsixuk.com"]

  spec.summary       = %q{Sanitizr database obfuscation}
  spec.description   = ""
  spec.homepage      = "http://github.com/cococoder/sanitizr"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8"


  spec.add_development_dependency "awesome_print", "~> 1.6"
  spec.add_development_dependency "pry", "~> 0.10.3"
  spec.add_development_dependency "byebug"

  spec.add_dependency "sequel","~> 4.27"
  spec.add_dependency "faker","~> 1.5"
  spec.add_dependency "solid-struct","~> 0.1.0"

end
