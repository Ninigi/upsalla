module Upsalla
  module Connectors
    class AddressValidation
      require "rest-client"

      @api_uri = "ups.app/xml/AV"

      def request(base_url, payload = {})
        credentials_xml = XMLParser.parse Connection.api_credentials
        payload_xml = XMLParser.parse payload
        uri = [base_url, self.class.api_uri].join "/"

        RestClient.post uri, [credentials_xml, payload_xml].join
      end

      class << self
        attr_accessor :api_uri
      end
    end
  end
end
