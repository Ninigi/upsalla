require "spec_helper"

RSpec.describe Upsalla::Connectors::RatingServiceSelection do
  let(:test_credentials) do
    {
      api_user: "TestUser",
      api_key: "123FromNewYorkToAPIKey",
      api_password: "TestPassword"
    }
  end

  before do
    test_credentials.each do |credential_key, credential|
      Upsalla.send "#{credential_key}=", credential
    end
  end

  subject { described_class.new }

  describe "#api_uri" do
    it "should return 'ups.app/xml/Rate'" do
      expect(subject.api_uri).to eq "ups.app/xml/Rate"
    end
  end

  describe "#request" do
    let(:url) { [Upsalla::Connection::TEST_URL, subject.api_uri].join("/") }

    let!(:request) do
      stub_request(:post, url)

      subject.request Upsalla::Connection::TEST_URL, test: "abc"
    end

    it "should make a request to #{described_class.new.api_uri}" do
      expect(WebMock).to have_requested(:post, url)
    end

    it "should return a <#Request> Object" do
      expect(request).to be_a Upsalla::Request
    end
  end
end
