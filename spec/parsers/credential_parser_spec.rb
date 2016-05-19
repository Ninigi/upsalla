require "spec_helper"

RSpec.describe Upsalla::CredentialParser do
  describe ".parse" do
    it "should return the api credentials in 'UPS xml'" do
      Upsalla.api_user = "Test User"
      Upsalla.api_key = "123FromNewYorkToAPIKey"
      Upsalla.api_password = "TestPassword"
      expected_xml =
        "<?xml version=\"1.0\" ?>"\
        "<AccessRequest>"\
          "<AccessLicenseNumber>#{Upsalla.api_key}</AccessLicenseNumber>"\
          "<UserId>#{Upsalla.api_user}</UserId>"\
          "<Password>#{Upsalla.api_password}</Password>"\
        "</AccessRequest>"\


      expect(described_class.parse Upsalla.api_credentials).to eq expected_xml
    end
  end
end
