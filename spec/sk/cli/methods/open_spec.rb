require 'spec_helper'
describe InstanceManager::CLI do
  context "without filters" do
    describe "#instances" do
      let(:instances) { InstanceManager::CLI.start(["open","-e","production"]) }
      it "should run the applescript" do
        InstanceManager::Actions::Open.any_instance.should_receive(:'`')
        instances
      end
    end
  end
end
