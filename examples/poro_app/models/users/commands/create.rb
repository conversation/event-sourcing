class PoroApp
  module Users
    module Commands
      class Create
        include EventSourcing::Command

        attributes :description, :name

        def validate!
          return false if description.to_s.length <= 5
          return false if name.to_s.length <= 5

          true
        end

        private

        def build_event
          PoroApp::Users::Events::Created.assign(
            active: true,
            description: description,
            name: name,
            visible: true,
          )
        end
      end
    end
  end
end
