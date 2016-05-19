module Upsalla
  class CredentialParser
    class << self
      def parse(api_credentials)
        ups_credentialized = {
          access_license_number: api_credentials[:api_key],
          user_id: api_credentials[:api_user],
          password: api_credentials[:api_password]
        }

        XMLParser.parse access_request: ups_credentialized
      end
    end
  end
end
