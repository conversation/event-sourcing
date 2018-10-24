class EventDispatcher < EventSourcing::EventDispatcher
  on Users::Events::Created, trigger: [Users::Reactors::SendGettingStartedEmail, Users::Reactors::LogUserChange]
  on Users::Events::Updated, trigger: Users::Reactors::LogUserChange
end
