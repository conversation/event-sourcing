module Users
  module Events
    class Base < ApplicationRecord
      include EventSourcing::Event
      include EventSourcing::Rails::EventRecord

      self.table_name = :user_events
      self.abstract_class = true

      belongs_to :user, class_name: "::User", autosave: false

      def dispatch
        puts "------------------"
        puts "TODO: DISPATCHING"
        puts "------------------"
      end
    end
  end
end
