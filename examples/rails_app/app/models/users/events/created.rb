module Users
  module Events
    class Created < Users::Events::Base
      data_attributes :active, :description, :name

      # @param [User] user
      # @return [User]
      def apply(user)
        user.active = active
        user.description = description
        user.name = name

        user
      end

      private

      def build_aggregate
        @user ||= ::User.new
      end
    end
  end
end
