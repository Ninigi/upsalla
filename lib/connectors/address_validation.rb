module Upsalla
  module Connectors
    class AddressValidation
      require "rest-client"

      attr_accessor :api_uri, :verify_ssl

      def initialize(options = {})
        self.api_uri = options[:address_validation_url] || "ups.app/xml/AV"
        self.verify_ssl = options[:verify_ssl].nil? ? true : options[:validate_ssl]
      end

      def request(base_url, payload = {})
        url = [base_url, api_uri].join "/"
        Request.new url, payload: payload, options: { verify_ssl: verify_ssl }
      end
    end
  end
end
