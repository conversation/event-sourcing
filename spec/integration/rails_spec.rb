require "rails_helper"

RSpec.describe "Rails workflow" do
  it "creates and updates an user through EventSourcing commands" do
    # Creates the user
    command = RailsUserCreateCommand.new(name: "My awesome name is John Doe")
    command.call

    expect(RailsUser.count).to eq(1)
    expect(RailsUserEvent.count).to eq(1)

    # Updates the user
    user = RailsUser.find_by(name: "My awesome name is John Doe")
    command = RailsUserUpdateCommand.new(name: "My new awesome name is Harry Doe", record_id: user.id)
    command.call

    expect(RailsUserEvent.count).to eq(2)

    # Events are able to be replayed
    events = RailsUserEvent.order(id: :asc)
    user = events.each_with_object(RailsUser.new) do |event, user_accumulator|
      event.replay(user_accumulator)
    end
    expect(user.name).to eq("My new awesome name is Harry Doe")
  end
end
