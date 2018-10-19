class PoroApp
  module Users
    module Events
      class Created < Base
        data_attributes :active, :description, :name, :visible

        # @param [PoroApp::User] user
        # @return [PoroApp::User]
        def apply(user)
          user.active = active
          user.description = description
          user.name = name
          user.visible = visible

          user
        end
      end
    end
  end
end
