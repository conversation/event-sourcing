require "spec_helper"

RSpec.describe EventSourcing::EventDispatcher do
  subject(:dispatcher) { described_class }

  class FakeCreatedEvent
  end

  class FakeMessageReactor
  end

  class FakeEmailReactor
  end

  before do
    dispatcher.on FakeCreatedEvent, trigger: [FakeMessageReactor, FakeEmailReactor]
  end

  describe ".on" do
    describe "register reactors to a given event" do
      let(:event) { FakeCreatedEvent.new }
      let(:reactors) { dispatcher.rules.for(event) }

      it "has reactors registered as synchronous events" do
        expect(reactors.sync).to include(FakeMessageReactor)
      end
    end
  end

  describe ".dispatch" do
    let(:event) { FakeCreatedEvent.new }

    before do
      allow(FakeMessageReactor).to receive(:call)
      allow(FakeEmailReactor).to receive(:call)

      dispatcher.dispatch(event)
    end

    it "calls synchronous events" do
      expect(FakeMessageReactor).to have_received(:call)
      expect(FakeEmailReactor).to have_received(:call)
    end
  end
end
