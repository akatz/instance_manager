require 'spec_helper'

describe InstanceManager::Connection do

  describe "#mock" do
    before :each do
      InstanceManager::Connection.mock!
    end
    it "should set mock on Fog" do
      Fog.mocking?.should be_true
    end
    it "should setup mock a mock ec2 connection" do
      InstanceManager::Connection.instance.compute_connection.should be_a(Fog::Compute::AWS::Mock)
    end
    it "should setup mock a mock rds connection" do
      InstanceManager::Connection.instance.compute_connection.should be_a(Fog::Compute::AWS::Mock)
    end
  end
  describe "#instance" do
    it "should return an instance of Connection" do
      InstanceManager::Connection.instance.should be_a(InstanceManager::Connection)
    end
  end

end
