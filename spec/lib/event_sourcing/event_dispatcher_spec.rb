require "spec_helper"

RSpec.describe EventSourcing::EventDispatcher do
  subject(:dispatcher) { described_class }

  class FakeCreatedEvent
  end

  class FakeMessageReactor
  end

  class FakeEmailReactor
  end

  class FakeLoggerReactor
  end

  before do
    dispatcher.on FakeCreatedEvent, trigger: FakeMessageReactor, async: [FakeEmailReactor, FakeLoggerReactor]
  end

  describe ".on" do
    describe "register sync and async reactors to a given event" do
      let(:event) { FakeCreatedEvent.new }
      let(:reactors) { dispatcher.rules.for(event) }

      it "has reactors registered as synchronous events" do
        expect(reactors.sync).to include(FakeMessageReactor)
      end

      it "has reactors registered as asynchronous events" do
        expect(reactors.async).to include(FakeEmailReactor, FakeLoggerReactor)
      end
    end
  end

  describe ".dispatch" do
    let(:event) { FakeCreatedEvent.new }

    before do
      allow(FakeMessageReactor).to receive(:call)
      allow(EventSourcing::ReactorJob).to receive(:perform_later)

      dispatcher.dispatch(event)
    end

    it "calls synchronous events" do
      expect(FakeMessageReactor).to have_received(:call)
    end

    it "delegates asynchronous events to reactor background job class" do
      expect(EventSourcing::ReactorJob).to have_received(:perform_later).with(event, "FakeEmailReactor")
      expect(EventSourcing::ReactorJob).to have_received(:perform_later).with(event, "FakeLoggerReactor")
    end
  end
end
