module Users
  module Commands
    class Create
      include EventSourcing::Command
      include EventSourcing::Rails::CommandRecord

      attributes :description, :name

      validates :description, presence: true, length: { minimum: 10 }
      validates :name, presence: true, length: { minimum: 5 }

      private

      def build_event
        Users::Events::Created.assign(
          active: true,
          description: description,
          name: name,
        )
      end
    end
  end
end
