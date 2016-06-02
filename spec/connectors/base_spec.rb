require "spec_helper"

RSpec.describe Upsalla::Connectors::Base do
  class DummyClass
    include Upsalla::Connectors::Base
    API_URI = "something".freeze
  end

  describe "accessors" do
    subject { DummyClass.new }

    expected_accessors = %i[api_uri options]

    expected_accessors.each do |accessor|
      it { is_expected.to respond_to accessor }
      it { is_expected.to respond_to "#{accessor}=" }
    end
  end

  describe "readers" do
    subject { DummyClass.new }

    expected_readers = %i[request_object]

    expected_readers.each do |reader|
      it { is_expected.to respond_to reader }
    end
  end

  it "should provide the initialize method" do
    some_different_option = "something/different"
    object = DummyClass.new api_uri: "something/different"

    expect(object.api_uri).to eq some_different_option
  end

  it "should provide the request method" do
    object = DummyClass.new

    expect(object).to respond_to :request
  end
end
