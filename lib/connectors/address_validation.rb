module Upsalla
  module Connectors
    class AddressValidation
      include Upsalla::Connectors::Base

      API_URI = "ups.app/xml/AV".freeze

      def build_payload(payload = {})
        {
          address_validation_request: {
            request: {
              request_action: "AV"
            },
            address: payload
          }
        }
      end
    end
  end
end
