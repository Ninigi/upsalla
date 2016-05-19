require "upsalla/version"

require "upsalla/connection"

require "connectors/address_validation"

require "parsers/xml_parser"

module Upsalla
  @api_key = ""
  @api_user = ""
  @api_password = ""

  @registered_apis = {
    address_validation: Connectors::AddressValidation
  }

  class << self
    attr_accessor :api_key, :api_user, :api_password, :registered_apis
  end
end
