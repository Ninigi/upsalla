require "spec_helper"

RSpec.describe Upsalla::Connectors::RatingServiceSelection do
  describe "#request#response" do
    context "when successfull" do
      let(:test_address) do
        {
          city: "Alpharetta",
          country_code: "US",
          postal_code: "30005"
        }
      end

      let(:success_stub) do
        # Original response from the example given in the official UPS API docs
        formated_response =
          <<-XMLResponse
            <?xml version=\"1.0\"?>
            <AddressValidationResponse>
              <Response>
                <TransactionReference></TransactionReference>
                <ResponseStatusCode>1</ResponseStatusCode>
                <ResponseStatusDescription>Success</ResponseStatusDescription>
              </Response>
              <AddressValidationResult>
                <Rank>1</Rank>
                <Quality>0.9875</Quality>
                <Address>
                  <City>ALPHARETTA</City>
                  <StateProvinceCode>GA</StateProvinceCode>
                </Address>
                <PostalCodeLowEnd>30005</PostalCodeLowEnd>
                <PostalCodeHighEnd>30005</PostalCodeHighEnd>
              </AddressValidationResult>
            </AddressValidationResponse>
          XMLResponse

        formated_response.delete("\n").gsub(/\s{2,}/, "")
      end

      let!(:request) do
        url = [Upsalla::Connection::TEST_URL, subject.api_uri].join("/")
        stub_request(:post, url).
          to_return(body: success_stub)

        subject.request Upsalla::Connection::TEST_URL, test_address
      end

      it "should return the response as a <#Hash> with the original keys" do
        expected_response = {
          "AddressValidationResponse" => {
            "Response" => {
              "TransactionReference" => nil,
              "ResponseStatusCode" => "1",
              "ResponseStatusDescription" => "Success"
            },
            "AddressValidationResult" => {
              "Rank" => "1",
              "Quality" => "0.9875",
              "Address" => {
                "City" => "ALPHARETTA",
                "StateProvinceCode" => "GA"
              },
              "PostalCodeLowEnd" => "30005",
              "PostalCodeHighEnd" => "30005"
            }
          }
        }
        expect(request.response).to eq expected_response
      end

      describe "#parsed_response" do
        it "should return a more concise version of #response" do
          expected_response = {
            "Rank" => "1",
            "Quality" => "0.9875",
            "Address" =>  {
              "City" => "ALPHARETTA",
              "StateProvinceCode" => "GA"
            },
            "PostalCodeLowEnd" => "30005",
            "PostalCodeHighEnd" => "30005"
          }

          expect(request.parsed_response).to eq expected_response
        end
      end
    end
  end

  context "when error" do
    let(:test_address) do
      {
        city: "Nonsense City"
      }
    end

    let(:error_stub) do
      # Original response to a random city name
      formated_response =
        <<-XMLResponse
          <?xml version=\"1.0\"?>
          <AddressValidationResponse>
            <Response>
              <TransactionReference></TransactionReference>
              <ResponseStatusCode>0</ResponseStatusCode>
              <ResponseStatusDescription>Failure</ResponseStatusDescription>
              <Error>
                <ErrorSeverity>Hard</ErrorSeverity>
                <ErrorCode>101112</ErrorCode>
                <ErrorDescription>No Address Candidate Found</ErrorDescription>
              </Error>
            </Response>
          </AddressValidationResponse>
        XMLResponse

      formated_response.delete("\n").gsub(/\s{2,}/, "")
    end

    let!(:request) do
      url = [Upsalla::Connection::TEST_URL, subject.api_uri].join("/")
      stub_request(:post, url).
        to_return(body: error_stub)

      subject.request Upsalla::Connection::TEST_URL, test_address
    end
    describe "#response" do
      it "should return the response as a <#Hash> with the original keys" do
        expected_response = {
          "AddressValidationResponse" => {
            "Response" => {
              "TransactionReference" => nil,
              "ResponseStatusCode" => "0",
              "ResponseStatusDescription" => "Failure",
              "Error" => {
                "ErrorSeverity" => "Hard",
                "ErrorCode" => "101112",
                "ErrorDescription" => "No Address Candidate Found"
              }
            }
          }
        }

        expect(request.response).to eq expected_response
      end
    end

    describe "#parsed_response" do
      it "should return a more concise version of #response" do
        expected_response = {
          "TransactionReference" => nil,
          "ResponseStatusCode" => "0",
          "ResponseStatusDescription" => "Failure",
          "Error" => {
            "ErrorSeverity" => "Hard",
            "ErrorCode" => "101112",
            "ErrorDescription" => "No Address Candidate Found"
          }
        }

        expect(request.parsed_response).to eq expected_response
      end
    end
  end
end
