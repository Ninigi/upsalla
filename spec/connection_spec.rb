require "spec_helper"

describe Upsalla::Connection do
  subject { Upsalla::Connection.new }

  Upsalla.registered_apis.each do |api_name, _connector|
    it "should initialize the connector ##{api_name}" do
      expect(subject).to respond_to api_name
    end
  end

  it "should have access to the API credentials" do
    expect(described_class.api_credentials).to be_a Hash
  end

  describe "access type" do
    context "when :access_type is :test" do
      subject { Upsalla::Connection.new access_type: :test }

      it "should connect to the ups test server" do
        expect(subject.api_url).to eq described_class::TEST_URL
      end
    end

    context "when :access_type is :production" do
      subject { Upsalla::Connection.new access_type: :production }

      it "should connect to the ups production server" do
        expect(subject.api_url).to eq described_class::PRODUCTION_URL
      end
    end

    context "when no :access_type is specified" do
      subject { Upsalla::Connection.new }

      it "should default to :test" do
        expect(subject.access_type).to eq :test
      end
    end
  end
end
