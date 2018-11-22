module Users
  module Events
    class Base < ApplicationRecord
      include EventSourcing::Event
      include EventSourcing::ActiveRecord::Event

      self.table_name = :user_events
      self.abstract_class = true

      belongs_to :user, class_name: "::User", autosave: false

      default_scope { where("metadata->>'klass' = ?", klass_name) }

      def dispatch
        EventDispatcher.dispatch(self)
      end
    end
  end
end
