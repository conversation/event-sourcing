require "spec_helper"

class UserCreatedEvent < EventSourcing::Event
  def persisted?
    false
  end
end

class UserReadEvent < EventSourcing::Event
  def persisted?
    true
  end
end

class UserCreateCommand < EventSourcing::Command
  attributes :id, :name

  def after_initialize
    @initialized = :yep!
  end

  def validate!
    true
  end

  def build_event
    UserCreatedEvent.new
  end
end

class UserUpdatedCommand < EventSourcing::Command
  def build_event
    nil
  end
end

class UserReadCommand < EventSourcing::Command
  def build_event
    UserReadEvent.new
  end
end

RSpec.describe EventSourcing::Command do
  let(:instance) { UserCreateCommand.new(id: 12345, name: "Mary Poppins") }

  describe ".initialize" do
    it "sets args hash as instance variables" do
      expect(instance.instance_variable_get(:@id)).to eq(12345)
      expect(instance.instance_variable_get(:@name)).to eq("Mary Poppins")
    end

    it "calls optional after initialization method" do
      expect(instance.instance_variable_get(:@initialized)).to eq(:yep!)
    end
  end

  describe ".attributes" do
    context "given class level defined attributes" do
      it "creates readers" do
        expect(instance.id).to eq(12345)
        expect(instance.name).to eq("Mary Poppins")
      end
    end

    describe "creates setters" do
      before do
        instance.id = 22222
        instance.name = "Julie Andrews"
      end

      it do
        expect(instance.id).to eq(22222)
        expect(instance.name).to eq("Julie Andrews")
      end
    end
  end

  describe "#call" do
    let(:instance) { UserUpdatedCommand.new }

    context "command doesn't need an event (nil event)" do
      it "does nothing" do
        expect(instance.call).to eq(:noop)
      end
    end

    context "event is persisted" do
      let(:instance) { UserReadCommand.new }

      it "raises error telling that event should not be persisted" do
        expect { instance.call }.to raise_error(RuntimeError, "The event should not be persisted at this stage!")
      end
    end

    context "event is not persisted" do
      let(:instance) { UserCreateCommand.new }

      before do
        allow(instance).to receive(:validate!)
        allow(instance.event).to receive(:save)
      end

      it "validates the command" do
        instance.call
        expect(instance).to have_received(:validate!)
      end

      it "executes the command (persists event)" do
        instance.call
        expect(instance.event).to have_received(:save)
      end

      it "returns the command's event" do
        expect(instance.call).to be_an_instance_of(UserCreatedEvent)
      end
    end
  end

  describe "#validate!" do
    let(:instance) { UserUpdatedCommand.new }

    it { expect { instance.validate! }.to raise_error(NotImplementedError) }
  end

  describe "#event" do
    let(:instance) { UserCreateCommand.new }

    it "builds events for the command" do
      expect(instance.event).to be_an_instance_of(UserCreatedEvent)
    end
  end
end
