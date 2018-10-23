require "rails_helper"

RSpec.describe EventSourcing::Rails::EventRecord do
  let(:event) { RailsUserCreated.assign(name: "John Doe") }
  let(:event_class) { RailsUserCreated }

  describe ".klass_name" do
    it "returns base class name" do
      expect(event_class.klass_name).to eq("RailsUserCreated")
    end
  end

  describe "Event's aggregate" do
    let(:user) { RailsUser.create(name: "John Doe") }

    before do
      event.persist_and_dispatch
      event.update(user_id: user.id)
    end

    describe "#aggregate_name" do
      it "returns the name of the event's belongs_to association" do
        expect(event.aggregate_name).to eq(:user)
      end
    end

    describe "#aggregate=" do
      let(:new_user) { RailsUser.create(name: "Harry Doe") }

      it "allows assigning an aggregate" do
        event.aggregate = new_user
        expect(event.aggregate).to eq(new_user)
      end
    end

    describe "#aggregate_id=" do
      let(:new_user) { RailsUser.create(name: "Harry Doe") }

      it "allows assigning the aggregate ID" do
        event.aggregate_id = new_user.id
        expect(event.aggregate_id).to eq(new_user.id)
      end
    end

    describe "#aggregate" do
      it "fetches event aggregate" do
        expect(event.aggregate).to eq(user)
      end
    end

    describe "#aggregate_id" do
      it "returns the belongs_to association ID" do
        expect(event.aggregate_id).to eq(user.id)
      end
    end
  end

  describe "Event data and metadata" do
    before { event.persist_and_dispatch }

    describe "#data" do
      it "returns event data as a Hash symbolized keys" do
        expect(event.data).to eq(name: "John Doe")
      end
    end

    describe "#metadata" do
      it "returns event metadata as a Hash symbolized keys" do
        expect(event.metadata).to eq(klass: "RailsUserCreated")
      end
    end
  end

  describe "Event persistence" do
    describe "#already_persisted?" do
      subject(:result) { event.already_persisted? }

      context "event is persisted" do
        before { event.persist_and_dispatch }

        it { is_expected.to eq(true) }
      end

      context "event is not persisted" do
        it { is_expected.to eq(false) }
      end
    end

    describe "#persist_event" do
      context "event does not have an aggregate" do
        it do
          expect { event.persist_event }.to raise_error(RuntimeError, "Event must have an aggregate!")
        end
      end

      context "event has an aggregate" do
        let(:aggregate) { RailsUser.new(name: "John Doe") }

        before { event.aggregate = aggregate }

        it "assigns data and metadata to event's database columns" do
          expect(event[:data]).to eq(nil)
          expect(event[:metadata]).to eq(nil)

          event.persist_event

          expect(event[:data]).to eq("name" => "John Doe")
          expect(event[:metadata]).to eq("klass" => "RailsUserCreated")
        end

        it "assigns aggregate association ID (persisting aggregate association)" do
          expect(event.aggregate_id).to eq(nil)

          event.persist_event

          expect(aggregate.persisted?).to eq(true)
          expect(event.aggregate_id).to eq(aggregate.id)
        end

        it "persists the event" do
          expect(event.persisted?).to eq(false)

          event.persist_event

          expect(event.persisted?).to eq(true)
        end
      end
    end
  end
end
