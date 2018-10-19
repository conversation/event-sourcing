module EventSourcing
  module Rails
    module EventRecord
      extend ActiveSupport::Concern

      included do
        default_scope { where("metadata->>'klass' = ?", klass_name) }
      end

      class_methods do
        def klass_name
          self.base_class.name
        end
      end

      # TODO: PROPERLY DOCUMENT THIS
      # TODO: ActiveRecord getters and setters are TOO POWERFUL! CANNOT REPLACE IT
      # TODO: So replacing POROs with ActiveRecords
      # Replaces aggregate getter and setter
      def aggregate=(object)
        public_send("#{aggregate_name}=", object)
      end

      def aggregate
        public_send(aggregate_name)
      end

      def aggregate_id=(id)
        public_send "#{aggregate_name}_id=", id
      end

      def aggregate_id
        public_send "#{aggregate_name}_id"
      end

      def data
        self[:data].transform_keys(&:to_sym)
      end

      def metadata
        self[:metadata].transform_keys(&:to_sym)
      end

      ###########################################################

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
