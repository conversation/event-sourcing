require "spec_helper"
require "ostruct"

class User
  attr_accessor :name
end

class CreatedEvent
  include EventSourcing::Event

end

class UpdatedEvent
  include EventSourcing::Event

  data_attributes :name

  def apply(user)
    user.name = name
    user
  end

  def build_aggregate
    self.aggregate ||= OpenStruct.new
  end

  def dispatch
    true
  end

  def persist_aggregate
    true
  end

  def persist_event
    true
  end
end

RSpec.describe EventSourcing::Event do
  let(:instance) { CreatedEvent.assign(attributes) }
  let(:attributes) { {} }

  describe ".assign" do
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

  describe "#already_persisted?" do
    it { expect(instance.already_persisted?).to eq(false) }
  end

  describe "#replay" do
    let(:aggregate) { User.new }
    let(:event) { UpdatedEvent.assign(name: "John Doe") }

    it "executes the event on the given aggregate" do
      event.replay(aggregate)
      expect(aggregate.name).to eq("John Doe")
    end
  end

  describe "#persist_and_dispatch" do
    let(:event) { UpdatedEvent.assign(name: "Aunt May") }

    before do
      allow(event).to receive(:persist_aggregate).and_call_original
      allow(event).to receive(:persist_event).and_call_original
      allow(event).to receive(:dispatch).and_call_original

      event.persist_and_dispatch
    end

    it "builds and apply changes to its aggregate" do
      aggregate = event.aggregate
      expect(aggregate.name).to eq("Aunt May")
    end

    it "calls instance's persist aggregate" do
      expect(event).to have_received(:persist_aggregate)
    end

    it "calls instance's persist event" do
      expect(event).to have_received(:persist_event)
    end

    it "calls dispatch" do
      expect(event).to have_received(:dispatch)
    end
  end

  describe "#persistence_wrapper" do
    let(:event) { UpdatedEvent.assign(name: "Aunt May") }
    let(:wrapped_double) { double("Wrapped Double", called: true) }

    it "yields the given block" do
      event.persistence_wrapper { wrapped_double.called }

      expect(wrapped_double).to have_received(:called)
    end
  end
end
