module Upsalla
  module Connectors
    class RatingServiceSelection
      include Upsalla::Connectors::Base

      API_URI = "ups.app/xml/Rate".freeze

      def build_payload(payload = {})
        {
          rating_service_selection_request: {
            request: {
              request_action: "Rate"
            },
            shipment: payload
          }
        }
      end
    end
  end
end
