require 'thor'

module ShopkeepManager
  class CLI < ::Thor

    desc "instances","return all instances from the shopkeep account"
    method_option :private_ip, :type => :boolean
    method_option :all_instances, :aliases => "-a", :type => :boolean, :default => false
    method_option :environment, :aliases => "-e"
    method_option :role, :aliases => "-r"
    method_option :type, :aliases => "-t"
    def instances(args=nil)
      ShopkeepManager::Actions::Instances.run(options,args)
    end

    desc "search TERM", "return all instances that match TERM"
    method_option :private_ip, :type => :boolean
    method_option :all_instances, :aliases => "-a", :type => :boolean, :default => false
    def search(args)
      ShopkeepManager::Actions::Search.run(options,args)
    end

    desc "open [options]", "open all matching instances in seperate tabs"
    method_option :private_ip, :type => :boolean
    method_option :all_instances, :aliases => "-a", :type => :boolean, :default => false
    method_option :environment, :aliases => "-e"
    method_option :role, :aliases => "-r"
    method_option :type, :aliases => "-t"
    def open(args=nil)
      ShopkeepManager::Actions::Open.run(options,args)
    end

    desc "ssh_config", "generate an ssh config for our servers"
    def ssh_config
      ShopkeepManager::Actions::SshConfig.run(options)
    end
    desc "console", "open the login url for shopkeeps aws portal"
    def console
      %x[open https://shopkeep.signin.aws.amazon.com/console]
    end
  end
end
