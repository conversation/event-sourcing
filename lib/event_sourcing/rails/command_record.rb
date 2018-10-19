module EventSourcing
  module Rails
    module CommandRecord
      extend ActiveSupport::Concern

      included do
        include ActiveModel::Validations
      end

      def validate!
        valid? || raise(ActiveRecord::RecordInvalid, self)
      end
    end
  end
end
