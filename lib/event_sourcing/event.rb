# This is the base `Event` class that all Events inherit from.
# It takes care of serializing `data` and `metadata`
# It defines setters and accessors for the defined `data_attributes`
# After create, it calls `apply` to apply changes.
#
# Subclasses must define the following methods:
# - `apply`
# - `build_aggregate`
# - `dispatch`
# - `persist`
# - `persisted?`
#
module EventSourcing
  class Event
    attr_reader :data, :metadata
    attr_accessor :aggregate

    # Define attributes to be serialized in the `data` column.
    # It generates setters and getters for those.
    #
    # Example:
    #
    # class MyEvent < Lib::BaseEvent
    #   data_attributes :title, :description, :drop_id
    # end
    #
    # MyEvent.create!(
    def self.data_attributes(*attrs)
      attrs.map(&:to_s).each do |attr|
        define_method attr do
          @data[attr.to_sym]
        end

        define_method "#{attr}=" do |arg|
          @data[attr.to_sym] = arg
        end
      end
    end

    # @param [Hash] attrs
    def initialize(attrs = {})
      @data = attrs
      @metadata = { klass: self.class.name }
    end

    # Apply the event to the aggregate passed in.
    # Must return the aggregate.
    def apply(_aggregate)
      raise NotImplementedError
    end

    # @return [TrueClass, FalseClass]
    def persisted?
      false
    end

    # Replays the event on any given aggregate
    # @param [Object] aggregate
    def replay(aggregate)
      event_class = Object.const_get(metadata[:klass])
      event_class.new(data).apply(aggregate)
    end

    # Persists and dispatches the event
    def save
      build_aggregate
      persist
      dispatch
    end

    private

    def build_aggregate
      raise NotImplementedError
    end

    # The base event class should dispatch the dispatcher implementation
    # Otherwise, event triggers won't be fired
    # Example: `MyApp::EventDispatcher.dispatch(self)`
    def dispatch
      raise NotImplementedError
    end

    # Persists the transformation event. Must be implemented.
    def persist
      raise NotImplementedError
    end
  end
end
