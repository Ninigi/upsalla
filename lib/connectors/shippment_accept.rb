module Upsalla
  module Connectors
    class ShipmentAccept
      require "rest-client"

      attr_accessor :api_uri, :options
      attr_reader :request_object

      def initialize(options = {})
        self.api_uri = options[:address_validation_url] || "ups.app/xml/ShipAccept"
        self.options = options
      end

      def request(base_url, payload = {})
        url = [base_url, api_uri].join "/"
        address_validation_payload = {
          shippment_accept_request: {
            request: {
              request_action: "ShipAccept",
              request_option: 1
            }
          }.merge(payload)
        }

        request_options = options.merge(response_key: self.class)

        @request_object = Request.new url, payload: address_validation_payload,
                                           options: request_options

        request_object
      end
    end
  end
end
