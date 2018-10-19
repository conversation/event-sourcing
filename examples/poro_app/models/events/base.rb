class PoroApp
  module Events
    class Base
      include EventSourcing::Event

      def persist_aggregate
        puts "-------PERSISTING AGGREGATE--------"
        puts self.aggregate.inspect
        puts "-----------------------------------"
      end

      def persist_event
        puts "-------PERSISTING EVENT--------"
        puts self.inspect
        puts "-------------------------------"
      end

      def dispatch
        PoroApp::EventDispatcher.dispatch(self)
      end
    end
  end
end
