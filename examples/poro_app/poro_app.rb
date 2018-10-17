require "event_sourcing"

Dir[File.join(Dir.pwd, "**/*.rb")].each { |file| require file }

class PoroApp
  def self.call
    puts "----------------------"
    puts "Running create command"
    puts "----------------------"
    create_command = PoroApp::Users::Commands::Create.new(description: "A super user", name: "John Doe")

    puts "Inspecting command: #{create_command.inspect}"
    puts "Command is valid?: #{create_command.validate!}"

    created_event = create_command.call

    puts "-----------------"
    puts "User was created."
    puts "Event details: #{created_event.inspect}"
    puts "-----------------"
  end
end
