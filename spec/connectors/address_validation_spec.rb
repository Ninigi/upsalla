require "spec_helper"

RSpec.describe Upsalla::Connectors::AddressValidation do
  let(:test_credentials) do
    {
      api_user: "TestUser",
      api_key: "123FromNewYorkToAPIKey",
      api_password: "TestPassword"
    }
  end

  describe ".api_uri" do
    it "should return 'ups.app/xml/AV'" do
      expect(described_class.api_uri).to eq "ups.app/xml/AV"
    end
  end

  describe "#request" do
    before do
      test_credentials.each do |credential_key, credential|
        Upsalla.send "#{credential_key}=", credential
      end
    end

    subject { described_class.new }

    it "should make a request to #{described_class.api_uri}" do
      url = [Upsalla::Connection::TEST_URL, described_class.api_uri].join("/")
      stub_request(:post, url)

      p subject.request Upsalla::Connection::TEST_URL, test: "abc"

      expect(WebMock).to have_requested(:post, url)
    end
  end
end
