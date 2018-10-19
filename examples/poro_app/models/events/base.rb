class PoroApp
  module Events
    class Base < EventSourcing::Event
      private

      def dispatch
        PoroApp::EventDispatcher.dispatch(self)
      end
    end
  end
end
