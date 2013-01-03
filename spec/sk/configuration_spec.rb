require 'spec_helper'

describe InstanceManager::Configuration do

  describe "#intialize" do
    before :each do
      File.open("/tmp/skconf","w") { |f| f.write "" }
    end
    it "should set fog_conf variable if passed in as an option" do
      conf = InstanceManager::Configuration.new(fog_conf_path: "/tmp/skconf")
      conf.fog_conf_path.should == "/tmp/skconf"
    end
    it "should set manager_conf variable if passed in as an option" do
      conf = InstanceManager::Configuration.new(manager_conf_path: "/tmp/skconf")
      conf.manager_conf_path.should == "/tmp/skconf"
    end
    it "should set fog_conf variable to the ones found in the file at the path" do
      options_file = write_options_file("/tmp/skconf",
                         { shopkeep:
                           { aws_access_key: "test", aws_secret_access_key: "test" }
                          }
                        )

      conf = InstanceManager::Configuration.new(fog_conf_path: options_file.path)
      conf.fog_conf[:shopkeep][:aws_access_key].should == "test"
    end
    it "should set manager_conf variables to the ones found in the file at the path" do
            options_file = write_options_file(
        "/tmp/opts", { :instance_manager => {:username => "akatz" } }
      )
      conf = InstanceManager::Configuration.new(manager_conf_path: options_file.path)
      conf.manager_conf[:instance_manager][:username].should == "akatz"
    end
  end
end

def write_options_file(location,hash)
  File.open(location,"w") do |file|
    file.write( YAML.dump( hash ) )
  end
  File.new(location)
end

