RSpec.describe EventSourcing do
  it "has a version number" do
    expect(EventSourcing::VERSION).not_to be(nil)
  end
end
