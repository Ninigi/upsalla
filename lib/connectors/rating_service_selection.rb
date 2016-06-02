module Upsalla
  module Connectors
    class RatingServiceSelection
      require "rest-client"

      attr_accessor :api_uri, :options
      attr_reader :request_object

      def initialize(options = {})
        self.api_uri = options[:address_validation_url] || "ups.app/xml/Rate"
        self.options = options
      end

      def request(base_url, payload = {})
        url = [base_url, api_uri].join "/"
        rating_payload = {
          rating_service_selection_request: {
            request: {
              request_action: "Rate"
            }
          },
          shipment: payload
        }

        request_options = options.merge(response_key: self.class)

        @request_object = Request.new url, payload: rating_payload,
                                           options: request_options

        request_object
      end
    end
  end
end
