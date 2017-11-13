lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "global-codecov"

Gem::Specification.new do |spec|
  spec.name          = Codecov::NAME
  spec.version       = Codecov::VERSION
  spec.authors       = ["saantiaguilera"]
  spec.email         = ["aguilerasanti@hotmail.com"]

  spec.summary       = %q{Codecov gem lets you run codecov for any language from ruby}
  spec.description   = ''
  spec.homepage      = "https://www.github.com/saantiaguilera/ruby-api-codecov"
  spec.license       = "BSD-3-Clause"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = Dir.glob("{bin,lib}/**/*") + ['README.md', 'LICENSE', 'CODE_OF_CONDUCT.md']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  #spec.add_dependency "shellwords"
  #spec.add_dependency "open-uri"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
