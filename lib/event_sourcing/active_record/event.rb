module EventSourcing
  module ActiveRecord
    module Event
      extend ActiveSupport::Concern

      class_methods do
        def klass_name
          self.base_class.name
        end
      end

      # An event's aggregate reflects the belonging model of a one-to-many association (an aggregate has many events).
      # This association should map to an `ActiveRecord.belongs_to` association. The methods below maps the belonging
      # model getters and setters. Example:
      #
      # The base event:
      #
      # ```
      # class Users::Events::Base < ApplicationRecord
      #   include EventSourcing::Event
      #   include EventSourcing::Rails::EventRecord
      #
      #   belongs_to :user
      # end
      # ```
      #
      # Will have the following method delegations:
      # - `Users::Events::Base#user=` -> `Users::Events::Base#aggregate=`
      # - `Users::Events::Base#user` -> `Users::Events::Base#aggregate`
      # - `Users::Events::Base#user_id=` -> `Users::Events::Base#aggregate_id=`
      # - `Users::Events::Base#user_id` -> `Users::Events::Base#aggregate_id`
      #
      def aggregate_name
        inferred_aggregate = self.class.reflect_on_all_associations(:belongs_to).first
        raise "Events must belong to an aggregate" if inferred_aggregate.nil?
        inferred_aggregate.name
      end

      def aggregate=(object)
        public_send("#{aggregate_name}=", object)
      end

      def aggregate
        public_send(aggregate_name)
      end

      def aggregate_id=(id)
        public_send("#{aggregate_name}_id=", id)
      end

      def aggregate_id
        public_send("#{aggregate_name}_id")
      end

      # Replaces `EventSourcing::Event#data` and `EventSourcing::Event#metadata` so it fetches
      # ActiveRecord's database column. This always returns a hash with `Symbol`s as keys
      def data
        self[:data].transform_keys(&:to_sym)
      end

      def metadata
        self[:metadata].transform_keys(&:to_sym)
      end

      # Delegates to `ActiveRecord#persisted?`
      def already_persisted?
        persisted?
      end

      def persist_aggregate
        aggregate.save!
      end

      def persist_event
        raise "Event must have an aggregate!" if aggregate.nil?

        self[:data] = @data
        self[:metadata] = @metadata
        self.aggregate_id = aggregate.id

        save!
      end

      # Creates a "nested transaction", forcing a SAVEPOINT in case the event persistence is
      # called inside an `ActiveRecord#transaction` block
      def persistence_wrapper
        ::ActiveRecord::Base.transaction(requires_new: true) do
          yield
        end
      end

      # @return [Class] Given class from metadata[:klass]
      # Materializes the event class from the database
      def reify
        event_class = Object.const_get(metadata[:klass])
        event_class.find(self[:id])
      end
    end
  end
end
