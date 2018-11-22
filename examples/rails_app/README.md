# Event Sourcing Rails app

This example implements a small portion of a system that handles its users as event sourced data.

To run it, first `bundle install`, you can run its binary execution file: `./examples/poro_app/bin/execute`.

# Known Caveats

Rails is a strong opinionated framework, so there are a couple of points to keep in mind:

- If your events inherit from a "base" event class, this base class should be abstract
    - Motive: `EventSourcing` uses the base class name to serialize the class type on event's metadata
    - Example:

```ruby
class BaseEvent < ApplicationRecord
  include EventSourcing::Event
  include EventSourcing::ActiveRecord::Event

  self.abstract_class = true
end
```

- When configuring Events `data_attributes`, do not use `id` as a keyword, as the attribute is used by
`ActiveRecord`'s persistence
    - Suggestion: instead of `id`, you can use `record_id`/`aggregate_id`
    - Example:

```ruby
class MyEvent < BaseEvent
  data_attributes :name, :record_id

  def apply(aggregate)
    aggregate.name = name
    aggregate
  end

  def build_aggregate
    @aggregate ||= MyModel.find(record_id)
  end
end

```

- Events must have a `belongs_to` relationship
    - Motive: this one-to-many association represents the events-aggregator relationship
    - Example:

```ruby
class BaseEvent < ApplicationRecord
  include EventSourcing::Event
  include EventSourcing::ActiveRecord::Event

  belongs_to :user
end
```

# Structure

## Events

- [Users Base event](app/models/users/events/base.rb)
    - Implements the base users event class, where:
        - It's defined as an abstract class
        - It's defined the `belongs_to` user association
        - Has a `default_scope` to allow inherited classes to be scoped by class
            - Example: `Users::Events::Updated.where(user_id: 32).count` will return all updated events of a user
        - Defines the event dispatcher class, where events should be dispatched after they occur
- [Users Created event](app/models/users/events/created.rb)
    - Event that applies changes for created users
    - Aggregate is a new record
- [Users Updated event](app/models/users/events/updated.rb)
    - Event that applies changes for an existent user
    - Aggregate is an existent record
- [Users Destroyed event](app/models/users/events/destroyed.rb)
    - Event that marks users as "deleted"
    - Aggregate is an existent record

## Commands

- [Create Command](app/models/users/commands/create.rb)
    - Handle user creation validations
    - Creates a "created" event after its call
- [Update Command](app/models/users/commands/update.rb)
    - Handle user update validations
    - Creates a "updated" event after its call
- [Destroy Command](app/models/users/commands/destroy.rb)
    - Handle user destroy action
    - Creates a "updated" event after its call

## Event Dispatcher

- [Event Dispatcher](app/models/event_dispatcher.rb)
    - Configure application reactors

## Reactors

Reactors are

- [Log User Change Reactor](app/models/users/reactors/log_user_change.rb)
- [Send Getting Started Email Reactor](app/models/users/reactors/send_getting_started_email.rb)

### Background Processing Reactors

Reactors are simple classes that must respond to a `.call` class method, receiving an event. As reactors are
synchronously executed after an event occurs, as background execution should be scheduled within the reactor.

Example:

```ruby
class SendEmailReactor
  def self.call(event)
    user = event.aggregate
    UserMailer.with(user: user).welcome_email.deliver_later
  end
end
```
