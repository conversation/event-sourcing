class PoroApp
  module Users
    module Reactors
      class SendGettingStartedEmail
        def self.call(event)
          puts "Reacting to event: #{event.class.name}, with data: #{event.data}"
        end
      end
    end
  end
end
