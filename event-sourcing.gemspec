lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "event_sourcing/version"
require "event_sourcing"

Gem::Specification.new do |spec|
  spec.name = "event-sourcing"
  spec.version = EventSourcing::VERSION
  spec.authors = ["The Conversation Dev Team"]

  spec.summary = "TC Event sourcing library"
  spec.description = "Event sourcing implementation for TC projects"
  spec.homepage = "https://github.com/conversation/tc-event-sourcing"
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|examples)/}) }
  end

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rails", ">= 5"
  spec.add_development_dependency "pg", ">= 1"
end
