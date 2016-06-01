module Upsalla
  module UPSResponse
    include Upsalla::StringHelper

    def parse_response(hash, klass = self.class)
      klass = demodulize klass.to_s
      _parse_from_class(hash, klass) || _guess_result(hash)
    end

    def parse_error_response(response_hash)
      response_hash = response_hash.values.first || {}

      response_hash.fetch("Response", {})
    end

    def _parse_from_class(hash, klass)
      parsed = hash.fetch("#{klass}Response", {})
      parsed["#{klass}Result"]
    end

    def _guess_result(hash)
      parsed = hash.values.first

      return {} if parsed.nil?

      guessed_result_key = parsed.keys.detect { |key| key.match(/result/i) }
      wild_guess_key = parsed.keys.detect { |key| key != "Response" }

      parsed[guessed_result_key] || parsed[wild_guess_key]
    end
  end
end
