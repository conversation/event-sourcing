module EventSourcing
  module Rails
    module CommandRecord
      extend ActiveSupport::Concern

      included do
        include ActiveModel::Validations
      end
    end
  end
end
