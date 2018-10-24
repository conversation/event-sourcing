module Users
  module Reactors
    class LogUserChange
      def self.call(event)
        puts "Log: Reacting to event: #{event.class.name}, with data: #{event.data}"
      end
    end
  end
end
