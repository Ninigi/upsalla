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

    context "when successfull" do
      let(:stub_success) do
        formated_response =
          <<-XMLResponse
            <?xml version=\"1.0\"?>
            <SomeResponse>
              <Response>
                <TransactionReference></TransactionReference>
                <ResponseStatusCode>1</ResponseStatusCode>
                <ResponseStatusDescription>Success</ResponseStatusDescription>
              </Response>
              <SomeResult>STUB!</SomeResult>
            </SomeResponse>
          XMLResponse

        formated_response.delete("\n").gsub(/\s{2,}/, "")
      end

      before { stub_request(:post, url).to_return(body: stub_success) }

      it "should set #status to 1" do
        request = described_class.new url, payload: {}

        request.perform

        expect(request.status).to be 1
      end
    end

    context "when error" do
      let(:stub_error) do
        formated_response = <<-XMLResponse
          <?xml version=\"1.0\"?>
          <SomeResponse>
            <Response>
              <TransactionReference></TransactionReference>
              <ResponseStatusCode>0</ResponseStatusCode>
              <ResponseStatusDescription>Failure</ResponseStatusDescription>
              <Error>
                <ErrorSeverity>Hard</ErrorSeverity>
                <ErrorCode>101112</ErrorCode>
                <ErrorDescription>Some Error</ErrorDescription>
              </Error>
            </Response>
          </SomeResponse>
        XMLResponse

        formated_response.delete("\n").gsub(/\s{2,}/, "")
      end

      let(:request) { described_class.new url, payload: {} }

      before do
        stub_request(:post, url).to_return(body: stub_error)
        request.perform
      end

      it "should set #status to 0" do
        expect(request.status).to be 0
      end

      it "should set #parsed_response to the 'Response' part of the response" do
        expected_parsed_response = {
          "TransactionReference" => nil,
          "ResponseStatusCode" => "0",
          "ResponseStatusDescription" => "Failure",
          "Error" => {
            "ErrorSeverity" => "Hard",
            "ErrorCode" => "101112",
            "ErrorDescription" => "Some Error"
          }
        }
        expect(request.parsed_response).to eq expected_parsed_response
      end
    end
  end
end
