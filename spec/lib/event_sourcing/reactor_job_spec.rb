require "spec_helper"

RSpec.describe EventSourcing::ReactorJob do
  subject(:job) { described_class.new }

  describe "#perform_later" do
    it "is not implemented by default" do
      expect { job.perform_later }.to raise_error(NotImplementedError)
    end
  end
end
