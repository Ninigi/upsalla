module Upsalla
  module Connectors
    module Base
      def initialize(options = {})
        self.api_uri = options[:api_uri] || self.class::API_URI
        self.options = options
      end

      def self.included(base)
        base.extend ClassMethods
        base.class_eval do
          attr_accessor :api_uri, :options
          attr_reader :request_object
        end
      end

      def request(base_url, payload = {})
        url = [base_url, api_uri].join "/"
        api_payload = build_payload payload

        request_options = options.merge(response_key: self.class)

        @request_object = Request.new url, payload: api_payload,
                                           options: request_options

        request_object
      end

      module ClassMethods
      end
    end
  end
end
