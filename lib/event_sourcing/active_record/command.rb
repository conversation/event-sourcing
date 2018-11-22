module EventSourcing
  module ActiveRecord
    module Command
      extend ActiveSupport::Concern

      included do
        include ActiveModel::Validations
      end
    end
  end
end
