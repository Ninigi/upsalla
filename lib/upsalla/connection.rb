module Upsalla
  class Connection
    require "rest-client"

    TEST_URL = "https://wwwcie.ups.com".freeze
    PRODUCTION_URL = "https://onlinetools.ups.com".freeze

    attr_accessor :api_url, :access_type, :options

    def initialize(options = {})
      self.access_type = options.delete(:access_type) || :test
      self.api_url = self.class._api_url_for_access_type access_type
      self.options = options

      _init_connector_methods
    end

    def _init_connector_methods
      class << self
        Upsalla.registered_apis.each do |method_name, connector_class|
          define_method method_name do |payload|
            connector = connector_class.new options

            connector.request api_url, payload
          end
        end
      end
    end

    class << self
      def api_credentials
        Upsalla.api_credentials
      end

      def api_credentials_xml
        CredentialParser.parse api_credentials
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
