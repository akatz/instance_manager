require 'spec_helper'
require 'shopkeep_manager/actions'

describe ShopkeepManager::Actions::Instances do
  describe "#find_instances" do
    context "without any options" do
      subject { ShopkeepManager::Actions::Instances.new({}) }
      it "should find all running instances" do
        subject.find_instances.map(&:id).should include(@production_web_1.id)
      end
    end
    context "with a filter for production" do
      subject { ShopkeepManager::Actions::Instances.new({environment: "production"}) }
      it "should only return the production instances" do
        production_ids = [@production_web_1, @production_worker_1, @production_web_marketing_1].map(&:id)
        subject.find_instances.map(&:id).should =~ production_ids
      end
    end
    context "with a filter for backoffice" do
      subject { ShopkeepManager::Actions::Instances.new({role: "backoffice"}) }
      it "should only return the backoffice instances" do
        backoffice_instances = [@production_web_1, @production_worker_1, @staging].map(&:id)
        subject.find_instances.map(&:id).should =~ backoffice_instances
      end
    end
    context "with a filter for databases" do
      subject { ShopkeepManager::Actions::Instances.new({type: "database"}) }
      it "should only return the backoffice instances" do
        database_instances = [@production_rds].map(&:id)
        subject.find_instances.map(&:id).should =~ database_instances
      end
    end
    context "with an amazon_id" do

    end
  end
end

