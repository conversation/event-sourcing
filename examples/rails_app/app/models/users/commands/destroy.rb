module Users
  module Commands
    class Destroy
      include EventSourcing::Command
      include EventSourcing::Rails::CommandRecord

      attributes :record_id

      private

      def build_event
        Users::Events::Destroyed.assign(record_id: record_id)
      end
    end
  end
end
