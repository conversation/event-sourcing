require "set"

module EventSourcing
  # Dispatcher implementation.
  class EventDispatcher
    # Register Reactors to Events, which will be synchronously triggered
    #
    # Example:
    #
    #   on BaseEvent, trigger: LogEvent
    #   on PledgeCancelled, PaymentFailed, trigger: [NotifyAdmin, CreateTask]
    #   on [PledgeCancelled, PaymentFailed], trigger: [NotifyAdmin, CreateTask]
    #
    def self.on(*events, trigger: [])
      rules.register(events: events.flatten, sync: Array(trigger))
    end

    # Dispatches events to matching Reactors once.
    # Called by all events after they are created.
    def self.dispatch(event)
      reactors = rules.for(event)
      reactors.sync.each { |reactor| reactor.call(event) }
    end

    def self.rules
      @rules ||= RuleSet.new
    end

    class RuleSet
      def initialize
        @rules ||= Hash.new { |h, k| h[k] = ReactorSet.new }
      end

      # Register events with their sync Reactors
      def register(events:, sync:)
        events.each do |event|
          @rules[event].add_sync sync
        end
      end

      # Return a ReactorSet containing all Reactors matching an Event
      def for(event)
        reactors = ReactorSet.new

        @rules.each do |event_class, rule|
          # Match event by class including ancestors. e.g. All events match a role for BaseEvent.
          if event.is_a?(event_class)
            reactors.add_sync rule.sync
          end
        end

        reactors
      end
    end

    # Contains sync reactors. Used to:
    # * store reactors via Rules#register
    # * return a set of matching reactors with Rules#for
    class ReactorSet
      attr_reader :sync

      def initialize
        @sync = Set.new
      end

      def add_sync(reactors)
        @sync += reactors
      end
    end
  end
end
