require_relative 'action'
module ShopkeepManager
  module Actions
    autoload :Instances, "shopkeep_manager/actions/instances"
    autoload :Search, "shopkeep_manager/actions/search"
    autoload :Open, "shopkeep_manager/actions/open"
    autoload :SshConfig, "shopkeep_manager/actions/ssh_config"
  end
end
