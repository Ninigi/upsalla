module Upsalla
  module Connectors
    class AddressValidation
      include Upsalla::Connectors::Base

      API_URI = "ups.app/xml/AV".freeze

      def build_payload(payload = {})
        request_hash = build_request default_request: { request_action: "AV" },
                                     body: payload.reject { |key, _val| key == :request },
                                     body_key: :address,
                                     request: payload[:request]
        {
          address_validation_request: request_hash
        }
      end
    end
  end
end
