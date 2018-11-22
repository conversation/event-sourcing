module Users
  module Commands
    class Update
      include EventSourcing::Command
      include EventSourcing::ActiveRecord::Command

      attributes :active, :description, :record_id, :name

      validates :record_id, presence: true
      validates :description, length: { minimum: 10 }, allow_blank: true
      validates :name, presence: true, length: { minimum: 5 }

      private

      def build_event
        Users::Events::Updated.assign(
          active: active,
          description: description,
          record_id: record_id,
          name: name,
        )
      end
    end
  end
end
