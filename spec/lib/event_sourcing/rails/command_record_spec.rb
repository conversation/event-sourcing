require "spec_helper"

require "active_support"
require "active_model"
require "active_record"
require "event_sourcing/rails"

class UserCreateCommand
  include EventSourcing::Command
  include EventSourcing::Rails::CommandRecord

  attributes :name

  validates :name, length: { minimum: 20 }
end

RSpec.describe EventSourcing::Rails::CommandRecord do
  subject(:command) { UserCreateCommand.new(name: given_name) }

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
