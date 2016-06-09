module Upsalla
  module Connectors
    # Including +Upsalla::Connectors::Base+ provides access to the basic
    # connector methods.
    #
    # A connector class needs to define two things to work:
    #
    # API_URI::                       Typically starts with "ups.app/something"
    # +build_payload(payload = {})+:: The method which will build the actual payload hash
    #
    # The +build_payload+ method requires a hash with the keys :body, :body_key and
    # :default_request and optionally :request.
    #
    # body::            The actual payload
    # body_key::        The key required by the UPS API
    # default_request:: Most API calls have a minimum requirement to what has to
    #                   be provided in <request></request>. You can implement
    #                   those minimum requirements in the default_request
    # request::         Enhances or overrides <request></request>
    #
    # === Example +AddressValidation+
    #
    #   class AddressValidation
    #     include Upsalla::Connectors::Base
    #
    #     API_URI = "ups.app/xml/AV".freeze
    #
    #     def build_payload(payload = {})
    #       request_hash = build_request default_request: { request_action: "AV" },
    #                                    body: payload.reject { |key, _val| key == :request },
    #                                    body_key: :address,
    #                                    request: payload[:request]
    #       {
    #        address_validation_request: request_hash
    #       }
    #     end
    #   end
    module Base
      # Initializes a connector object.
      # Options can include:
      #
      # api_uri:: Overrides the API_URI constant
      #
      # And all options that RestClient::Request.execute[https://github.com/rest-client/rest-client/blob/master/lib/restclient/request.rb] accepts.
      def initialize(options = {})
        self.api_uri = options[:api_uri] || self.class::API_URI
        self.options = options
      end

      def self.included(base) #:nodoc:
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

        @request_object = Upsalla::Request.new url, payload: api_payload,
                                                    options: request_options

        request_object
      end

      def build_request(unparsed_payload = {})
        fail_if_keys_missing! unparsed_payload, :body, :body_key,
                              :default_request

        optional = unparsed_payload[:request].to_h
        request_hash = unparsed_payload[:default_request].reject { |key, _val| optional.keys.include? key }

        request_hash.merge unparsed_payload[:request].to_h

        {
          request: request_hash,
          unparsed_payload[:body_key] => unparsed_payload[:body]
        }
      end

      def fail_if_keys_missing!(hash = {}, *keywords)
        missing_keys = keywords - hash.keys

        return if missing_keys.empty?

        fail ArgumentError, "missing keys: #{missing_keys.join(', ')}"
      end

      module ClassMethods
      end
    end
  end
end
