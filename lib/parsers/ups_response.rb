module Upsalla
  module UPSResponse
    def parse_response(hash, klass = self.class)
      parsed = hash["#{klass}Response"] || {}
      parsed["#{klass}Result"]
    end
  end
end
