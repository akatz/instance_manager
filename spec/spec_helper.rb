require 'rspec'
require 'fog'
require 'shopkeep_manager'

$0 = "sk"
ARGV.clear

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end

  result
end


#Fog::Mock.delay=0

#File.open("/tmp/fog","w") do |file|
  #file.write(YAML.dump({
      #shopkeep:{
        #aws_access_key_id: "test",
        #aws_secret_access_key: "test"
      #}
    #})
  #)
#end
#Fog.credentials_path = "/tmp/fog"
#Fog.credential = :shopkeep
RSpec.configure do |config|
  config.before(:each) do
    ShopkeepManager::Connection.mock!
    @conn = ShopkeepManager::Connection.instance.compute_connection
    @rds_conn = ShopkeepManager::Connection.instance.rds_connection
    @staging = @conn.servers.create({
        "tags" => {
                 "Name" => "sk-stage-1",
                 "Role" => "web nginx backoffice marketing partners",
          "Environment" => "staging"
        }
      })
    @production_web_1 = @conn.servers.create({
        "tags" => {
          "Name"        => "sk-backoffice-production-web-1",
          "Role"        => "web backoffice",
          "Environment" => "production"
        }
      })
    @production_worker_1 = @conn.servers.create({
        "tags" => {
          "Name"        => "sk-backoffice-production-worker-1",
          "Role"        => "worker backoffice",
          "Environment" => "production"
        }
      })
    @production_web_stopped_1 = @conn.servers.create({
        "tags" => {
          "Name"        => "sk-backoffice-production-web-2",
          "Role"        => "web backoffice",
          "Environment" => "production"
        }
      })
    @production_web_stopped_1.stop

    @production_web_marketing_1 = @conn.servers.create({
        "tags" => {
          "Name"        => "sk-marketing-production-web-1",
          "Role"        => "web marketing",
          "Environment" => "production"
        }
      })
    @production_rds = @rds_conn.servers.create({
            "id"                => Fog::Mock.random_letters(rand(9) + 8),
            "engine"            => "mysql",
            "allocated_storage" => 50,
            "master_username"   => "root",
            "password"          => "root"
    })

    @all_ec2_instances = [@staging, @production_web_1, @production_worker_1, @production_web_marketing_1]
  end
  config.after(:each) do
    [@staging, @production_web_1, @production_worker_1, @production_web_stopped_1, @production_web_marketing_1, @production_rds].each(&:destroy)
  end
end
