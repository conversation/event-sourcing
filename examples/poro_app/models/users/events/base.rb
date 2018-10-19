require_relative "../../events/base"

class PoroApp
  module Users
    module Events
      class Base < PoroApp::Events::Base
        private

        def persist
          puts "-------PERSISTENCE--------"
          puts self.aggregate.inspect
          puts "--------------------------"
        end

        def build_aggregate
          self.aggregate ||= PoroApp::User.new
        end
      end
    end
  end
end
