require 'spec_helper'

describe ShopkeepManager::CLI do
  context "#search" do
    shared_examples_for "a search" do
      it "should not return any production instances" do
        results = capture(:stdout) { instances }
        results.should_not =~ /#{@production_web_1.id}/
        results.should_not =~ /#{@production_web_stopped_1.id}/
        results.should_not =~ /#{@production_worker_1.id}/
      end
    end

    describe "with an amazon_id" do
      let(:instances) { ShopkeepManager::CLI.start(["search","#{@staging.id}"]) }
       it "should return the information for that instance" do
         results = capture(:stdout) { instances }
         results.should =~ /#{@staging.id}/
       end
      it_behaves_like "a search"
    end

    describe "with a public ip address" do
      let(:instances) { ShopkeepManager::CLI.start(["search","#{@staging.public_ip_address}"]) }
      it "should return the information for that instance" do
        results = capture(:stdout) { instances }
        results.should =~ /#{@staging.id}/
      end
      it_behaves_like "a search"
    end

    describe "with a private ip address" do
      before(:each) do
        @private_dns_name = @staging.private_dns_name
        @staging.connection.data[:instances][@staging.id]["privateIpAddress"] = "10.1.1.1"
        @staging.reload
      end
      let(:instances) { ShopkeepManager::CLI.start(["search","#{@staging.private_ip_address}"]) }
      it "should return the information for that instance" do
        results = capture(:stdout) { instances }
        results.should =~ /#{@staging.id}/
      end
      it_behaves_like "a search"
    end

    describe "with a private hostname that starts with ip- and has no .ec2.internal suffix" do
      let(:instances) { ShopkeepManager::CLI.start(["search","#{@staging.private_dns_name.gsub(/.ec2.internal/,"")}"]) }

      it "should return the information for that instance" do
        results = capture(:stdout) {instances}
        results.should =~ /#{@staging.id}/
      end
      it_behaves_like "a search"
    end

    describe "with a private hostname that starts with domU- and has no .compute-1.local suffix" do
      before(:each) do
        @private_dns_name = @staging.private_dns_name
        @staging.connection.data[:instances][@staging.id]["privateDnsName"] = "domU-12-31-39-04-E1-1B.compute-1.internal"
        @staging.reload
      end
      after(:each) do
        @staging.connection.data[:instances][@staging.id]["privateDnsName"] = @private_dns_name
        @staging.reload
      end
      let(:instances) { ShopkeepManager::CLI.start(["search","#{@staging.private_dns_name.gsub(/.compute-1.internal/,"")}"]) }

      it "should return the information for that instance" do
        results = capture(:stdout) {instances}
        results.should =~ /#{@staging.id}/
      end
      it_behaves_like "a search"
    end

    describe "with a private hostname that starts with ip- and ends in .ec2.internal" do
      let(:instances) { ShopkeepManager::CLI.start(["search","#{@staging.private_dns_name}"]) }

      it "should return the information for that instance" do
        results = capture(:stdout) {instances}
        results.should =~ /#{@staging.id}/
      end
      it_behaves_like "a search"
    end

    describe "with a public hostname" do
      let(:instances) { ShopkeepManager::CLI.start(["search","#{@staging.dns_name}"]) }

      it "should return the information for that instance" do
        results = capture(:stdout) {instances}
        results.should =~ /#{@staging.id}/
      end
      it_behaves_like "a search"
    end
  end
end

