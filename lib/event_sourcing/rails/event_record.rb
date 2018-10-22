module EventSourcing
  module Rails
    module EventRecord
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

      private

      def aggregate_name
        inferred_aggregate = self.class.reflect_on_all_associations(:belongs_to).first
        raise "Events must belong to an aggregate" if inferred_aggregate.nil?
        inferred_aggregate.name
      end

      def persist_aggregate
        aggregate.save!
      end

      def persist_event
        self[:data] = @data
        self[:metadata] = @metadata
        self.aggregate_id = aggregate.id if aggregate_id.nil?

        save!
      end
    end
  end
end
