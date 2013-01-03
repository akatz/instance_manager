require 'singleton'
require 'fog'


module InstanceManager
  class Connection
    include Singleton

    attr_reader :compute_connection, :rds_connection, :configuration
    def initialize
      if Fog.mocking?
        mock_config
      else
        real_config
      end
      create_connections
    end

    def self.mock!
        Fog.mock!
        Fog::Mock.delay=0
    end

    def mock_config
      @configuration = Configuration.new(
        {
          fog_conf_path: "/tmp/skmock",
          manager_conf_path: "/tmp/skmock"
        }
      )
      Fog.credentials_path = configuration.fog_conf_path
      Fog.credentials = { aws_access_key_id: "test",
                          aws_secret_access_key: "test"
                         }
    end

    def real_config
      @configuration = Configuration.new
      Fog.credentials_path = @configuration.fog_conf_path
    end

    def create_connections

      @compute_connection = Fog::Compute.new(:provider => 'AWS')
      @rds_connection = Fog::AWS::RDS.new
    end
  end


end
