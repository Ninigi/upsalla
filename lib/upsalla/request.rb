module Upsalla
  class Request
    require "crack/xml"

    attr_accessor :url, :payload, :options, :complete_payload
    attr_reader :error, :error_message, :request_hash, :response_raw, :response

    def initialize(url, options = {})
      self.payload = options.delete(:payload)
      self.url = url
      self.options = options.delete(:options).to_h

      _fail_if_missing_attributes

      begin
        perform
      rescue StandardError => e
        @error = e
      end
    end

    def perform
      self.complete_payload = Connection.api_credentials.merge payload

      credentials_xml = Connection.api_credentials_xml
      payload_xml = XMLParser.parse payload
      complete_payload_xml = [credentials_xml, payload_xml].join

      @request_hash = {
        method: :post,
        url: url,
        payload: complete_payload_xml
      }

      @response_raw = RestClient::Request.execute request_hash.merge options
      @response = Crack::XML.parse response_raw
    end

    def _fail_if_missing_attributes
      { payload: payload, url: url }.each do |argument_name, argument|
        if argument.nil?
          @error = ArgumentError
          @error_message = "missing Argument: #{argument_name}"
          fail error, error_message
        end
      end
    end
  end
end
