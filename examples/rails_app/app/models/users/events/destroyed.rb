module Users
  module Events
    class Destroyed < Users::Events::Base
      data_attributes :record_id

      # @param [User] user
      # @return [User]
      def apply(user)
        user.deleted_at = Time.zone.now
        user
      end

      private

      def build_aggregate
        @user ||= ::User.find(record_id)
      end
    end
  end
end
