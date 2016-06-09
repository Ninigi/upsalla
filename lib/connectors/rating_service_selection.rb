module Upsalla
  module Connectors
    class RatingServiceSelection
      include Upsalla::Connectors::Base

      API_URI = "ups.app/xml/Rate".freeze

      def build_payload(payload = {})
        request_hash = build_request default_request: { request_action: "Rate" },
                                     body: payload.reject { |key, _val| key == :request },
                                     body_key: :shipment,
                                     request: payload[:request]
        {
          rating_service_selection_request: request_hash
        }
      end
    end
  end
end
