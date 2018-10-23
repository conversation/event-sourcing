# The Base command mixin that commands include.
#
# A Command has the following public api.
#
# ```
#   MyCommand.call(user: ..., post: ...) # shorthand to initialize, validate and execute the command
#   command = MyCommand.new(user: ..., post: ...)
#   command.valid? # true or false
#   command.call # validate and execute the command
# ```
#
# Commands including the `EventSourcing::Command` mixin must:
# * list the attributes the command takes
# * implement `build_event` which returns a non-persisted event or nil for noop.
#
# Example:
#
# ```
#   class MyCommand
#     include EventSourcing::Command
#
#     attributes :user, :post
#
#     def build_event
#       Event.new(...)
#     end
#   end
# ```
#
# Subclasses must define the following methods:
#
# - `build_event`
# - `validate!`
#
# You can also implement an optional `after_initialize` method, which can be used to set commands' default values
# after its initialization. Example:
#
# ```
#   class MyCommand
#     include EventSourcing::Command
#
#     attributes :active
#
#     def after_initialize
#       self.active = true
#     end
#   end
# ```
#
module EventSourcing
  module Command
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Run validations and persist the event.
      #
      # On success: returns the event
      # On noop: returns nil
      # On failure: raise an ActiveRecord::RecordInvalid error
      def call(args = {})
        new(args).call
      end

      # Define the attributes.
      # They are set when initializing the command as a hash and
      # are all accessible as getter methods.
      #
      # ex: `attributes :post, :user, :ability`
      def attributes(*args)
        attr_accessor(*args)
      end
    end

    # @param [Hash<Symbol, Object>] args
    def initialize(args = {})
      args.each { |key, value| instance_variable_set("@#{key}", value) }
      after_initialize
    end

    def call
      return :noop if event.nil?
      raise "The event should not be persisted at this stage!" if event.already_persisted?

      validate!
      execute!

      event
    end

    def validate!
      raise NotImplementedError
    end

    # A new event or nil if noop
    def event
      @event ||= build_event
    end

    private

    # Save the event. Should not be overwritten by the command as side effects
    # should be implemented via Reactors triggering other Events.
    def execute!
      event.persist_and_dispatch
    end

    # Returns a new event record or nil if noop
    def build_event
      raise NotImplementedError
    end

    # Hook to set default values
    def after_initialize
      # noop
    end
  end
end
