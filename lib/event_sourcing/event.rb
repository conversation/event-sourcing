# This is the base `Event` class that all Events inherit from.
# It takes care of serializing `data` and `metadata`
# It defines setters and accessors for the defined `data_attributes`
# After create, it calls `apply` to apply changes.
#
# Subclasses must define the following methods:
#
# - `already_persisted?`
# - `apply`
# - `build_aggregate`
# - `dispatch`
# - `persist_aggregate`
# - `persist_event`
#
# Example:
#
# ```
# class MyEvent
#   include EventSourcing::Event
#
#   def persist_aggregate
#     # Define your aggregate persistence method here
#   end
#
#   def persist_event
#     # Define your event persistence method here
#   end
#
#   def dispatch
#     # Define your custom dispatcher here
#   end
#
#   def build_aggregate
#     self.aggregate ||= MyAggregate.new
#   end
# end
# ```
#
module EventSourcing
  module Event
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # @param [Hash] attrs
      def assign(attrs = {})
        metadata = attrs[:metadata] || {}

        self.new.tap do |instance|
          instance.instance_variable_set(:@data, attrs)
          instance.instance_variable_set(:@metadata, metadata.merge(klass: klass_name))
        end
      end

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
      def data_attributes(*attrs)
        attrs.map(&:to_s).each do |attr|
          define_method attr do
            @data ||= {}
            @data[attr.to_sym]
          end

          define_method "#{attr}=" do |arg|
            @data ||= {}
            @data[attr.to_sym] = arg
          end
        end
      end

      def klass_name
        self.name
      end
    end

    attr_reader :data, :metadata
    attr_accessor :aggregate

    # Apply the event to the aggregate passed in.
    # Must return the aggregate.
    def apply(_aggregate)
      raise NotImplementedError
    end

    # Redundant name to avoid clashing with ActiveRecord's `#persisted?` method
    # @return [TrueClass, FalseClass]
    def already_persisted?
      false
    end

    # Replays the event on any given aggregate
    # @param [Object] aggregate
    def replay(aggregate)
      event_class = Object.const_get(metadata[:klass])
      event_class.assign(data).apply(aggregate)
    end

    def persist_and_dispatch
      self.aggregate = build_aggregate

      # Apply
      self.aggregate = apply(aggregate)

      # Persist aggregate
      persist_aggregate
      persist_event

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

    # Persists the aggregate. Must be implemented.
    def persist_aggregate
      raise NotImplementedError
    end

    # Persists the transformation event. Must be implemented.
    def persist_event
      raise NotImplementedError
    end
  end
end
