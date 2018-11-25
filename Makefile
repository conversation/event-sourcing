.PHONY: test build tag push clean release

version := $(shell ruby -r ./lib/event_sourcing/version.rb -e "puts EventSourcing::VERSION")

test:
	@bundle exec rspec spec

build:
	@gem build event-sourcing.gemspec

tag:
	@git tag $(version)
	@git push --tags

push: build
	@gem push "event-sourcing-${version}.gem"

clean:
	@rm "event-sourcing-${version}.gem"

release: build tag push clean
