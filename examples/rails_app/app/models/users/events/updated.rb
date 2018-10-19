module Users
  module Events
    class Updated < Users::Events::Base
      include EventSourcing::Event
      include EventSourcing::Rails::EventRecord

      data_attributes :active, :description, :id, :name

      # @param [User] user
      # @return [User]
      def apply(user)
        user.active = active if active.present?
        user.description = description if description.present?
        user.name = name

        user
      end

      private

      def build_aggregate
        @user ||= ::User.find(id)
      end
    end
  end
end
