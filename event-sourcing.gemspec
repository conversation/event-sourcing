lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "event_sourcing/version"

Gem::Specification.new do |spec|
  spec.name = "event-sourcing"
  spec.version = EventSourcing::VERSION
  spec.authors = ["The Conversation Dev Team"]

  spec.summary = "The Conversation Event sourcing library"
  spec.description = "Simple Ruby Event Sourcing framework, with Rails support"
  spec.homepage = "https://github.com/conversation/event-sourcing"
  spec.license = "MIT"

  spec.files = `git ls-files -- lib/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "pg", "~> 1.0"
  spec.add_development_dependency "rails", "~> 5.0", "< 6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
