module Upsalla
  module Connectors
    class ShipmentAccept
      include Upsalla::Connectors::Base

      API_URI = "ups.app/xml/ShipAccept".freeze

      def build_payload(payload = {})
        {
          shippment_accept_request: {
            request: {
              request_action: "ShipAccept",
              request_option: 1
            }
          }.merge(payload)
        }
      end
    end
  end
end
