require "spec_helper"

RSpec.describe Upsalla::Request do
  let(:url) { "http://test.com" }
  before { stub_request(:post, url) }

  describe ".new(url, options)" do
    it "should send a request" do
      described_class.new url, payload: {}
      expect(WebMock).to have_requested(:post, url)
    end

    context "when options[:payload].nil?" do
      it "should raise ArgumentError" do
        expect { described_class.new url, options: {} }.
          to raise_error ArgumentError
      end
    end

    context "when url.nil?" do
      it "should raise ArgumentError" do
        expect { described_class.new nil, payload: { xml: "test" } }.
          to raise_error ArgumentError
      end
    end
  end

  describe "#perform" do
    it "should send the request again" do
      request = described_class.new url, payload: {}

      request.perform

      expect(WebMock).to have_requested(:post, url).times 2
    end
  end
end
