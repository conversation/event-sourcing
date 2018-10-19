module Users
  module Commands
    class Update
      include EventSourcing::Command
      include EventSourcing::Rails::CommandRecord

      attributes :active, :description, :id, :name

      validates :id, presence: true
      validates :description, length: { minimum: 10 }, allow_blank: true
      validates :name, presence: true, length: { minimum: 5 }

      private

      def build_event
        Users::Events::Updated.assign(
          active: active,
          description: description,
          id: id,
          name: name,
        )
      end
    end
  end
end
