require 'spec_helper'
describe ShopkeepManager::CLI do
  context "without filters" do
    describe "#ssh_config" do
      let(:ssh_config) { ShopkeepManager::CLI.start(["ssh_config"]) }
      it "should generate an ssh config with all the instances" do
        results = capture(:stdout) { ssh_config }
        expected_results = ""
        @all_ec2_instances.each do |ins|
          expected_results << <<-EOF.gsub(/^[^\n]\s{1,11}/,"")
            Host #{ins.tags["Name"]}

            HostName #{ins.public_ip_address}
            User #{ins.username}


          EOF
        end
        results.should == expected_results
      end
    end
  end
end

