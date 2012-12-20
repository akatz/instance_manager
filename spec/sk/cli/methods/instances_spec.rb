require 'spec_helper'

describe ShopkeepManager::CLI do

  context "without filters" do
    describe "#instances" do
      let(:instances) { ShopkeepManager::CLI.start(["instances"]) }
       it "outputs the ids of all running instances under our account" do
          results = capture(:stdout) { instances }
          results.should =~ /#{@production_web_1.id}/
       end
       it "should output a description with the id" do
         results = capture(:stdout) { instances }
         results.should =~ /prod/
       end
       it "should output the ip address to access the instance as well" do
         results = capture(:stdout) { instances }
         results.should =~ /ip: (\d{1,3}\.){3}\d{1,3}/
       end
       it "should output the private hostname for comparison with newrelic" do
         results = capture(:stdout) { instances }
         results.should =~ /private hostname: (ip|domU)-(\d{1,3}-){1,5}(\d+)(\.(\w|-)+)+/
       end
       it "should not output stopped instances by default" do
         results = capture(:stdout) { instances }
         results.should_not =~ /#{@production_web_stopped_1.id}/
       end
    end
  end
  context "with a filter" do
    let(:all_instances) { ShopkeepManager::CLI.start(["instances", "-a"]) }
    let(:no_instances) { ShopkeepManager::CLI.start(["instances", "-r", "failcase"]) }
    context "for environment" do
      let(:production_instances) { ShopkeepManager::CLI.start(["instances","-e", "production"]) }
      it "should output only instances that are tagged with the production environment" do
           results = capture(:stdout) { production_instances }
           results.should =~ /#{@production_web_1.id}/
           results.should =~ /#{@production_worker_1.id}/
           results.should =~ /#{@production_web_marketing_1.id}/
           results.should_not =~ /#{@staging.id}/
      end
    end
    context "for type" do
      let(:database_instances) { ShopkeepManager::CLI.start(["instances","-t", "database"]) }
      it "should output only the db instances" do
        results = capture(:stdout) { database_instances }
        results.should =~ /#{@production_rds.id}/
        results.should_not =~ /#{@production_web_1.id}/
        results.should_not =~ /#{@production_worker_1.id}/
        results.should_not =~ /#{@production_web_marketing_1.id}/
      end

    end
    context "for role" do
      let(:backoffice_instances) { ShopkeepManager::CLI.start(["instances","-r", "backoffice"]) }
      it "should output only instances that are tagged with the backoffice role" do
           results = capture(:stdout) { backoffice_instances }
           results.should =~ /#{@staging.id}/
           results.should =~ /#{@production_web_1.id}/
           results.should =~ /#{@production_worker_1.id}/
           results.should_not =~ /#{@production_web_marketing_1.id}/
      end
    end
    it "should output stopped instances with the correct flag" do
         results = capture(:stdout) { all_instances }
         results.should =~ /#{@production_web_stopped_1.id}/
    end
    it "should provide a nice message if nothing matched" do
      results = capture(:stdout) { no_instances }
      results.should ==<<-EOF.gsub(/^\s{8}/,"")
        No Instances Matched
          role: failcase
      EOF
    end
  end
  context "with multiple filters" do
    let(:backoffice_instances) { ShopkeepManager::CLI.start(["instances","-r", "backoffice", "-e", "prod"]) }
    let(:no_instances) { ShopkeepManager::CLI.start(["instances", "-r", "failcase", "-e","w00t"]) }

    it "should output only instances that match both filters" do
      results = capture(:stdout) { backoffice_instances }
      results.should =~ /#{@production_web_1.id}/
      results.should =~ /#{@production_worker_1.id}/
      results.should_not =~ /#{@staging.id}/
      results.should_not =~ /#{@production_web_marketing_1}/
    end

    it "should provide a nice message if nothing matched" do
      results = capture(:stdout) { no_instances }
      results.should ==<<-EOF.gsub(/^\s{8}/,"")
        No Instances Matched
          env: w00t
          role: failcase
      EOF
    end

  end
  context "with uppercase filters" do
    let(:backoffice_instances) { ShopkeepManager::CLI.start(["instances","-r", "Backoffice", "-e", "Prod"]) }
    it "should output instances that match upper and lowercase" do
      results = capture(:stdout) { backoffice_instances }
      results.should =~ /#{@production_web_1.id}/
      results.should =~ /#{@production_worker_1.id}/
      results.should_not =~ /#{@staging.id}/
      results.should_not =~ /#{@production_web_marketing_1}/
    end
  end
  context "with an amazon_id" do
    let(:single_instance) { ShopkeepManager::CLI.start(["instances",@production_web_1.id]) }

    it "should output only that instance" do
      results = capture(:stdout) { single_instance }
      results.should =~ /#{@production_web_1.id }/
    end
  end
end

