# EventSourcing

Simple Ruby Event Sourcing framework, with Rails support. Inspired by [Kickstarter](https://www.kickstarter.com/)'s 
["Event Sourcing made Simple"](https://kickstarter.engineering/event-sourcing-made-simple-4a2625113224) blog post.

`EventSourcing` gives you a toolset to configure and store sequences of events on any Ruby application, making it 
possible to query an object state at any given point of time.

As Martin Fowler describes the Event Sourcing concept:  

> Event Sourcing ensures that all changes to application state are stored as a sequence of events. Not just can we query 
these events, we can also use the event log to reconstruct past states, and as a foundation to automatically adjust the 
state to cope with retroactive changes.
> - Source: https://martinfowler.com/eaaDev/EventSourcing.html

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'event-sourcing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install event-sourcing
    
## Concepts

This frameworks introduces artifacts and rules to keep track of object state changes.

The core artifacts of this framework are:

- **Aggregates**: represent the current state of the application
    - Usually they are persistence objects, such as "models"
- **Events**: provide history of an aggregate, applying changes to an aggregate
    - "Applying" an event is also known as "Calculator" on other event sourcing literature
- **Commands**: validates and persists events
- **Reactors**: trigger side effects as events happen
- **Event Dispatcher**: manage which reactors will be executed after an event happens

While state changing actions obey the rationale:

- Aggregate state changes should be executed through a Command
- Events are immutable, as they represent series of changes to an Aggregate
- Reactors may be triggered after an Event occurs

## Usage

This framework can be used on any Ruby project, as it allows you to customize how you can handle Event persistence and
event dispatching control flow.

You can find an implementation sample at the [PORO app's README file](examples/poro_app/README.md).  

## Usage with Rails

You can also use this framework with Rails, as it includes an `event_sourcing/rails` module to ease up configuration.

**Note:** this Rails implementation requires a database that implements serializable attributes by default,
such as PostgreSQL JSON/Binary JSON columns.

To include the Rails module, add this line to your application's Gemfile:

```ruby
gem "event-sourcing", require: "event_sourcing/rails"
```

Further installation steps and a sample implementation can be found at the [Rails' README file](examples/rails_app/README.md).

## Contributing

- System requirements
    - Postgres 8.4+
    - Ruby 2.3+

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. 

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Bug reports and pull requests are welcome on GitHub at https://github.com/conversation/event-sourcing.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere

to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Code of Conduct

Everyone interacting in the The Conversation project’s codebases, issue trackers, chat rooms and mailing lists is
expected to follow the [code of conduct](https://github.com/conversation/event-sourcing/blob/master/CODE_OF_CONDUCT.md).

## Related Projects

Thank you very much [Kickstarter](https://www.kickstarter.com/) for making the ["Event Sourcing made Simple"](https://kickstarter.engineering/event-sourcing-made-simple-4a2625113224)
blog post. This project is heavily inspired on concepts described on it and its [Rails demo app](https://github.com/pcreux/event-sourcing-rails-todo-app-demo). 
