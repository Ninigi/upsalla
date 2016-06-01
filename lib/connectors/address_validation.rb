module Upsalla
  module Connectors
    class AddressValidation
      require "rest-client"

      attr_accessor :api_uri, :options
      attr_reader :request_object

      def initialize(options = {})
        self.api_uri = options[:address_validation_url] || "ups.app/xml/AV"
        self.options = options
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

        request_options = options.merge(response_key: self.class)

        @request_object = Request.new url, payload: address_validation_payload,
                                           options: request_options

        request_object
      end
    end
  end
end
