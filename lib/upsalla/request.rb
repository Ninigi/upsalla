module Upsalla
  class Request
    require "crack/xml"
    require "parsers/ups_response"

    include Upsalla::UPSResponse

    attr_accessor :url, :payload, :options, :complete_payload
    attr_reader :error, :error_message, :request_hash,
                :raw_response, :response, :parsed_response,
                :status

    def initialize(url, options = {})
      self.payload = options.delete(:payload)
      self.url = url
      self.options = options.delete(:options).to_h

      _fail_if_missing_attributes

      begin
        perform
      rescue StandardError => e
        @status = 0
        _set_internal_error e, e.message
      end
    end

    def perform
      self.complete_payload = Connection.api_credentials.merge payload

      @request_hash = {
        method: :post,
        url: url,
        payload: _complete_payload_xml
      }

      @raw_response = RestClient::Request.execute request_hash.merge options
      @response = Crack::XML.parse raw_response

      @status = parse_status_from response

      _set_parsed_response
    end

    # response_hash should look something like this:
    #  => {
    #       "AddressValidationResponse"=> {
    #         "Response" => {
    #           "ResponseStatusCode" => "0",
    #           ...
    #         }
    #       }
    #     }
    def parse_status_from(response_hash = {})
      response_hash = response_hash.values.first || {}

      response_hash.
        fetch("Response", {})["ResponseStatusCode"].to_i
    end

    def _set_parsed_response
      @parsed_response =
        if status == 1
          return unless options[:response_key]
          parse_response response, options[:response_key]
        else
          error_response = parse_error_response response
          error = Upsalla::ResponseIsError.new error_response.fetch("Error", {})
          _set_internal_error error, error.message
          error_response
        end
    end

    def _fallback_error
      {
        "ErrorSeverity" => "Hard",
        "ErrorCode" => "2020",
        "ErrorDescription" => "Unknown Error"
      }
    end

    def _fail_if_missing_attributes
      { payload: payload, url: url }.each do |argument_name, argument|
        next if argument

        _set_internal_error ArgumentError, "missing Argument: #{argument_name}"
        fail error, error_message
      end
    end

    def _complete_payload_xml
      credentials_xml = Connection.api_credentials_xml
      payload_xml = XMLParser.parse payload

      [credentials_xml, payload_xml].join
    end

    def _set_internal_error(er, msg)
      @error = er
      @error_message = msg
    end
  end
end
