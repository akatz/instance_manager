require 'spec_helper'
require 'shopkeep_manager/actions'

describe ShopkeepManager::Actions::Open do
  describe "#open" do
    it "should use the user specified in the options file to login" do
      options_file = write_options_file(
        "/tmp/opts", { :instance_manager => {:username => "akatz" } }
      )
      opener = ShopkeepManager::Actions::Open.new(
        {:options_file => options_file.path}
      )
      template = opener.applescript
      template.should =~ /akatz@/
    end
    it "should default to deploy if no user exists in the options file" do
      options_file = write_options_file(
        "/tmp/opts", { }
      )
      opener = ShopkeepManager::Actions::Open.new(
        {:options_file => options_file.path}
      )
      template = opener.applescript
      template.should =~ /deploy@/
    end
    context "without any options" do
      subject { ShopkeepManager::Actions::Open.new({}) }
      it "should render a template that includes all the running instances" do
        template = subject.applescript
        [@production_web_1,@production_worker_1,
         @production_web_marketing_1, @staging].each do |server|
          template.should =~ /#{server.id}/
        end
        template.should_not =~ /#{@production_web_stopped_1.id}/
      end
    end
    context "with a filter" do

      subject { ShopkeepManager::Actions::Open.new({environment: "production"}) }
      it "should render a template that only includes production instances" do
        template = subject.applescript
        template.should =~ /#{@production_web_1.id}/
        template.should =~ /#{@production_worker_1.id}/
        template.should =~ /#{@production_web_marketing_1.id}/
        template.should_not =~ /#{@production_web_stopped_1.id}/
        template.should_not =~ /#{@staging.id}/
      end
    end
  end
end



private

def write_options_file(location,hash)
  File.open(location,"w") do |file|
    file.write( YAML.dump( hash ) )
  end
  File.new(location)
end
