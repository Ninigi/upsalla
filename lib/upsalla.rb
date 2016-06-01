require "upsalla/version"

require "helpers/string_helper"

require "exceptions"

require "upsalla/connection"

require "upsalla/request"

require "connectors/address_validation"
require "connectors/shippment_accept"
require "connectors/rating_service_selection"

require "parsers/xml_parser"
require "parsers/credential_parser"

module Upsalla
  @api_key = ""
  @api_user = ""
  @api_password = ""

  @registered_apis = {
    address_validation: Connectors::AddressValidation
  }

  class << self
    attr_accessor :api_key, :api_user, :api_password, :registered_apis

    def api_credentials
      credential_names = %i[api_key api_user api_password]

      mapped_credentials = credential_names.map do |credential_name|
        [credential_name, send(credential_name)]
      end

      Hash[mapped_credentials]
    end
  end
end
