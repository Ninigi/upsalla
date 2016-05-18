require "upsalla/version"

require "upsalla/connection"

module Upsalla
  DEFAULT_APIS = {
    address_validation: ::AddressValidation
  }

  @api_key = ""
  @api_user = ""
  @api_password = ""

  @registered_apis = DEFAULT_APIS

  class << self
    attr_accessor :api_key, :api_user, :api_password, :registered_apis
  end
end
