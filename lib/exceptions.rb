module Upsalla
  class Exception < StandardError
    attr_reader :message

    def initialize(message = nil)
      @message = message
    end

    def to_s
      @message
    end
  end

  class ResponseIsError < Exception
    include StringHelper

    def initialize(response_hash = {})
      response_hash = _fallback_error if response_hash.empty?

      response_hash.each do |error_key, error_val|
        normalized_key = snake_case error_key.to_s

        self.class.send :attr_reader, normalized_key
        instance_variable_set "@#{normalized_key}", error_val
      end

      super response_hash["ErrorDescription"]
    end

    def _fallback_error
      {
        "ErrorSeverity" => "Hard",
        "ErrorCode" => "2020",
        "ErrorDescription" => "Unknown Error"
      }
    end
  end
end
