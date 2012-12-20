require 'spec_helper'

describe ShopkeepManager::InstanceFormatter do
  context "with a single ec2 instance" do
    subject { ShopkeepManager::InstanceFormatter.new(@staging) }
    it "should output the information we care about" do

output=<<EOF
#{@staging.id} => #{@staging.tags["Name"]}
  ip: #{@staging.public_ip_address}
  private hostname: #{@staging.private_dns_name}
EOF

      subject.format_output.should == output
    end
  end
  context "with an array of ec2 instances" do
    subject { ShopkeepManager::InstanceFormatter.new([@staging,@staging]) }
    it "should output the information of every server we care about" do

      output=<<-EOF.gsub(/^[^\n]\s{1,8}/,"")
        #{@staging.id} => #{@staging.tags["Name"]}
           ip: #{@staging.public_ip_address}
           private hostname: #{@staging.private_dns_name}

        #{@staging.id} => #{@staging.tags["Name"]}
           ip: #{@staging.public_ip_address}
           private hostname: #{@staging.private_dns_name}
      EOF

      subject.format_output.should == output

    end
  end
  context "with no instances" do
    subject { ShopkeepManager::InstanceFormatter.new }
    it "should output that nothing matched" do
      subject.format_output.should == "No Instances Matched"
    end
  end
  context "with an instance that has no tags or no name tag" do
    before(:each) do
      @instance = @conn.servers.new
      @instance_with_tags = @conn.servers.new("tags" => {"test" => "test"})
    end
    subject { ShopkeepManager::InstanceFormatter.new(@instance) }
    it "should not raise an error" do
      expect{ subject.format_output }.to_not raise_error
      expect{ ShopkeepManager::InstanceFormatter.new(@instance_with_tags).format_output }.to_not raise_error
    end
  end
  context "with a single rds instance" do
    before do
      @production_rds.reload
    end
    subject { ShopkeepManager::InstanceFormatter.new(@production_rds) }
    it "should format correctly" do
      output =<<-EOF.gsub(/^\s{8}/,"")
        #{@production_rds.id}
        Endpoint: #{@production_rds.endpoint["Address"]}
        Type: Master
      EOF
      subject.format_output.should ==  output
    end
  end
end
