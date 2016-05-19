require "spec_helper"

RSpec.describe Upsalla::Request do
  let(:url) { "http://test.com" }
  before { stub_request(:post, url) }

  describe ".new(url, options)" do
    it "should send a request" do
      described_class.new url, payload: { xml: "test" }
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

    context "when the request raises an error" do
      before do
        allow(RestClient::Request).to receive(:execute).and_throw(:standard_error)
      end

      it "should catch that error" do
        expect { described_class.new url, payload: {} }.not_to raise_error
      end

      it "should assign #error" do
        request = described_class.new url, payload: {}

        expect(request.error).not_to be_nil
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
