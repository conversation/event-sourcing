class PoroApp
  class EventDispatcher < EventSourcing::EventDispatcher
    on PoroApp::Users::Events::Created, trigger: PoroApp::Users::Reactors::SendGettingStartedEmail
  end
end
