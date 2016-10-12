# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'peictt/version'

Gem::Specification.new do |spec|
  spec.name          = "peictt"
  spec.version       = Peictt::VERSION
  spec.authors       = ["Tijesunimi Peters"]
  spec.email         = ["tijesunimi.peters@andela.com"]

  spec.summary       = %q{Microframe work just better than sinatra}
  spec.description   = %q{This is going to be a better version of sinatra but not as heavy as rails}
  spec.homepage      = "https://github.com/andela-tpeters/peictt"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["peictt"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_runtime_dependency "rack", "~> 1.6"
  spec.add_runtime_dependency 'haml', '~> 4.0'
  spec.add_runtime_dependency 'puma', '~> 3.6'
  spec.add_runtime_dependency 'require_all', '~> 1.3'
  spec.add_runtime_dependency "thor", "0.19.1"
  spec.add_runtime_dependency "activesupport", "5.0.0.1"
  spec.add_runtime_dependency "sqlite3", "~> 1.3"
end
