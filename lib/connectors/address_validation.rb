module Upsalla
  module Connectors
    class AddressValidation
      require "rest-client"
      require "parsers/ups_response"

      include Upsalla::UPSResponse

      attr_accessor :api_uri, :verify_ssl
      attr_reader :request_object, :response

      def initialize(options = {})
        self.api_uri = options[:address_validation_url] || "ups.app/xml/AV"
        self.verify_ssl = options[:verify_ssl].nil? ? true : options[:verify_ssl]
      end

      def request(base_url, payload = {})
        url = [base_url, api_uri].join "/"
        address_validation_payload = {
          address_validation_request: {
            request: {
              request_action: "AV"
            },
            address: payload
          }
        }

        @request_object = Request.new url, payload: address_validation_payload,
                                           options: { verify_ssl: verify_ssl }

        @response = parse_response request_object.response

        request_object
      end
    end
  end
end
