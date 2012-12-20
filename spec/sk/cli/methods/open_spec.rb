require 'spec_helper'
describe ShopkeepManager::CLI do
  context "without filters" do
    describe "#instances" do
      let(:instances) { ShopkeepManager::CLI.start(["open","-e","production"]) }
      it "should run the applescript" do
        ShopkeepManager::Actions::Open.any_instance.should_receive(:'`')
        instances
      end
    end
  end
end
