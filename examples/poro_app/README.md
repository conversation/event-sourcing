# Event Sourcing PORO app

This example implements a small portion of a system that handles its users as event sourced data.

To execute a sample run of it, you can run its binary execution file: `./examples/poro_app/bin/execute`.

# Structure

## Events

- [Base event](models/events/base.rb)
    - Implements persistence of any aggregator and inherited events
    - Defines the event dispatcher class, where events should be dispatched after they occur
- [Created User event](models/users/events/created.rb)
    - Builds a new user as its aggregate
    - Applies changes to the newly built user aggregate

## Commands

- [Create User command](models/users/commands/create.rb)
    - Handle user creation validations
    - Creates a "created" event after its call

## Event Dispatcher

- [Event Dispatcher](models/event_dispatcher.rb)
    - Configure application reactors

## Reactors

[Send Getting Started Email reactor](models/users/reactors/send_getting_started_email.rb)
    - Reactor called after an user creation, which would trigger an email message
