# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hiera/backend/yamll_backend'

Gem::Specification.new do |spec|
  spec.name          = "hiera-yamll"
  spec.version       = Hiera::Backend::Yamll_backend::VERSION
  spec.authors       = ["Corey Osman"]
  spec.email         = ["corey@nwops.io"]

  spec.summary       = %q{Another hiera backend for yaml}
  spec.description   = %q{A hiera backend that allows you to use a secondary yaml backend for hiera}
  spec.homepage      = "https://www.github.com/nwops/hiera-backend-yamll"
  spec.license       = "MIT"

  # # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency 'pry'
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
