require_relative 'action'
module InstanceManager
  module Actions
    autoload :Instances, "instance_manager/actions/instances"
    autoload :Search, "instance_manager/actions/search"
    autoload :Open, "instance_manager/actions/open"
    autoload :SshConfig, "instance_manager/actions/ssh_config"
  end
end
