# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "piga/version"

Gem::Specification.new do |spec|
  spec.name     = "piga"
  spec.version  = Piga::VERSION
  spec.authors  = ["Mark Delk"].freeze
  spec.email    = "jethrodaniel@gmail.com"
  spec.summary  = "simple PEG grammar generator that consumes tokens"
  spec.homepage = "https://github.com/jethrodaniel/msh/lib/piga"
  spec.license  = "MIT"
  spec.metadata = {
    "allowed_push_host" => "TODO: Set to 'https://rubygems.org'",
    "source_code_uri" => spec.homepage,
    "homepage_uri" => spec.homepage
  }
  spec.files = %w[
    readme.md
    piga.gemspec
    license.txt
    exe/piga
  ] + Dir.glob("man/man1/*") + Dir.glob("lib/**/*.rb")

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.5"

  spec.add_dependency "ast", "~> 2.4"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rexical", "~> 1.0"

  if RUBY_ENGINE == "ruby"
    spec.add_development_dependency "pry"
    spec.add_development_dependency "pry-byebug"
  end
end
