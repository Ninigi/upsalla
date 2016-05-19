module Upsalla
  class Connection
    require "rest-client"

    TEST_URL = "https://wwwcie.ups.com".freeze
    PRODUCTION_URL = "https://onlinetools.ups.com".freeze

    attr_accessor :api_url, :access_type

    def initialize(options = {})
      self.access_type = options[:access_type] || :test
      self.api_url = self.class._api_url_for_access_type access_type

      init_connector_methods
    end

    def init_connector_methods
      Upsalla.registered_apis.each do |method_name, connector|
        define_method method_name do |payload|
          connector.request payload, api_url
        end
      end
    end

    class << self
      def api_credentials
        credential_names = %i[api_key api_user api_password]

        mapped_credentials = credential_names.map do |credential_name|
          [credential_name, Upsalla.send(credential_name)]
        end

        Hash[mapped_credentials]
      end

      def _api_url_for_access_type(access_type)
        case access_type
        when "test", :test
          TEST_URL
        when "production", :production
          PRODUCTION_URL
        else
          fail ArgumentError, ":#{access_type} is not a valid access type"
        end
      end
    end
  end
end
