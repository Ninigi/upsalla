require "spec_helper"

describe Upsalla::Connection do
  describe "helper methods" do
    describe "._api_url_for_access_type(access_type)" do
      valid_types = %i[test production]
      test_url = described_class::TEST_URL
      production_url = described_class::PRODUCTION_URL

      valid_types.each do |valid_type|
        it "should validate the access_type '#{valid_type}' as valid" do
          expect { described_class._api_url_for_access_type valid_type }.
            not_to raise_error
        end
      end

      it "should validate everything not in #{valid_types.inspect} as invalid" do
        expect { described_class._api_url_for_access_type :not_a_valid_type }.
          to raise_error ArgumentError
      end

      context "when access_type == :test" do
        it "should return '#{test_url}'" do
          expect(described_class._api_url_for_access_type :test).to eq test_url
        end
      end

      context "when access_type == :production" do
        it "should return '#{production_url}'" do
          expect(described_class._api_url_for_access_type :production).
            to eq production_url
        end
      end
    end
  end
end
