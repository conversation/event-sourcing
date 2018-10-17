require "spec_helper"

class User
  attr_accessor :name
end

class CreatedEvent < EventSourcing::Event
end

class UpdatedEvent < EventSourcing::Event
  data_attributes :name

  def apply(user)
    user.name = name
    user
  end
end

RSpec.describe EventSourcing::Event do
  let(:instance) { CreatedEvent.new(attributes) }
  let(:attributes) { {} }

  describe ".initialize" do
    let(:attributes) { { id: 12345, name: "John Doe" } }

    it "initializes event's data" do
      expect(instance.data).to eq(id: 12345, name: "John Doe")
    end

    it "initializes event's metadata" do
      expect(instance.metadata).to eq(klass: "CreatedEvent")
    end
  end

  describe "#apply" do
    let(:aggregate) { User.new }

    it { expect { instance.apply(aggregate) }.to raise_error(NotImplementedError) }
  end

  describe "#persisted?" do
    it { expect(instance.persisted?).to eq(false) }
  end

  describe "#replay" do
    let(:aggregate) { User.new }
    let(:event) { UpdatedEvent.new(name: "John Doe") }

    it "executes the event on the given aggregate" do
      event.replay(aggregate)
      expect(aggregate.name).to eq("John Doe")
    end
  end

  describe "#save" do
    let(:event) { UpdatedEvent.new(name: "Aunt May") }

    before do
      allow(event).to receive_messages(build_aggregate: true, persist: true)
      allow(EventSourcing::EventDispatcher).to receive(:dispatch)

      event.save
    end

    it "calls instance's build aggregate" do
      expect(event).to have_received(:build_aggregate)
    end

    it "calls event dispatcher dispatch" do
      expect(EventSourcing::EventDispatcher).to have_received(:dispatch).with(event)
    end

    it "calls instance's persist" do
      expect(event).to have_received(:persist)
    end
  end
end
