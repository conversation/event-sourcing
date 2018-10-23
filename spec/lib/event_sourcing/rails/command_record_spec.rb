require "rails_helper"

RSpec.describe EventSourcing::Rails::CommandRecord do
  subject(:command) { RailsUserCreateCommand.new(name: given_name) }

  let(:given_name) { "Not long enough" }

  describe "allows ActiveModel validations" do
    context "validate name's length" do
      before do
        command.name = given_name
        command.valid?
      end

      it do
        expect(command.errors.messages).to eq(name: ["is too short (minimum is 20 characters)"])
      end
    end
  end
end
